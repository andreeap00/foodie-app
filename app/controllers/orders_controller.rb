class OrdersController < ApplicationController
  before_action :authenticate, only: [:add_to_order, :remove_from_order]

  def show
    @order = current_user.orders.find(params[:id])
    if @order
      @order_products = @order.order_products.includes(:product)
    else
      flash[:error] = "Not Found Order"
      redirect_to home_path
    end
  end

  def archive
    @order = current_user.orders.find(params[:id])
    if @order
      @order.update(is_archived: true)
      flash[:success] = 'Order archived'
      redirect_to home_path
    else
      flash[:error] = "Not Found Order"
      redirect_to home_path
    end
  end

  def purchase
    @order = current_user.orders.find(params[:id]) 
    if @order.present?
      if @order.update(status: 'pending')
        flash[:success] = "Successfully purchased products."
      else
        flash[:error] = "Purchasing Products not Accomplished"
      end
    else
      flash[:error] = "Not Found Order"
    end
    redirect_to order_path(@order)
  end

  def add_to_order
    @order = current_user.orders.find_or_create_by(status: 'cart')
    product = Product.find(params[:product_id])
    order_product = @order.order_products.find_or_initialize_by(product: product)

    if order_product.new_record?
      order_product.quantity = 1
    else
      order_product.quantity += 1
    end

    if order_product.save
      flash[:success] = "#{product.title} successfully added to cart."
    else
      flash[:error] = " #{product.title} not added to cart."
    end

    redirect_to order_path(current_user.orders.last)
  end

  def remove_from_order
    @order = current_user.orders.find_or_create_by(status: 'cart')
    product = Product.find(params[:product_id])
    order_product = @order.order_products.find_by(product: product)

    flash[:error] = "#{product.title} not found in the cart." unless order_product.present?

    if order_product.quantity > 1
      decrease_quantity(order_product)
    else
      remove_product(order_product)
    end

    redirect_to order_path(current_user.orders.last)
  end

  private

    def decrease_quantity(order_product)
      order_product.quantity -= 1
      order_product.save
      flash[:success] = "#{order_product.quantity} #{order_product.product.title} rest."
    end

    def remove_product(order_product)
      order_product.destroy
      flash[:success] = "#{order_product.product.title} removed from your order."
    end
end
