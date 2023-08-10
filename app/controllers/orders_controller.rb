class OrdersController < ApplicationController
  before_action :logged_in?, only: [:add_to_order, :remove_from_order]

  def show
    @order = current_user.orders.find(params[:id])
    @order_products = @order.order_products.includes(:product)
  end

  def add_to_order
    @order = current_user.orders.find_or_create_by(status: 'cart')
    product = Product.find(params[:product_id])
    order_product = @order.order_products.find_or_initialize_by(product: product)

    order_product.quantity = 1 if order_product.new_record?
    order_product.quantity += 1 unless order_product.new_record?

    flash[:success] = "#{product.title} successfully added to cart." if order_product.save
    flash[:error] = " #{product.title} not added to cart." unless order_product.save
  end

  def remove_from_order
    @order = current_user.orders.find_or_create_by(status: 'cart')
    product = Product.find(params[:product_id])
    order_product = @order.order_products.find_by(product: product)

    flash[:error] = "#{product.title} not found in the cart." unless order_product.present?
    decrease_quantity(order_product) if order_product.quantity > 1
    remove_product(order_product) unless order_product.quantity > 1

    redirect_to order_path(@order)
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
