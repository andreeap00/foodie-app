class Api::V1::OrdersController < Api::V1::ApplicationController
  before_action :authenticate, only: [:add_to_order, :remove_from_order]
  include UserAuthorization

  def show
    @order = current_user.orders.find(params[:id])
    if @order
      @order_products = @order.order_products.includes(:product)
      render json: @order, include: { order_products: { include: :product } }
    else
      render json: { error: "Not Found Order" }, status: :not_found
    end
  end

  def purchase
    @order = current_user.orders.find(params[:id]) 
    if @order.present?
      if @order.update(status: 'pending')
        render json: { success: "Successfully purchased products." }, status: :ok
      else
        render json: { error: "Purchasing Products not Accomplished" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Not Found Order" }, status: :not_found
    end
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
      render json: { success: "#{product.title} successfully added to cart." }
    else
      render json: { error: "#{product.title} not added to cart." }, status: :unprocessable_entity
    end
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
  end

  private

  def decrease_quantity(order_product)
    order_product.quantity -= 1
    order_product.save
    render json: { success: "#{order_product.quantity} #{order_product.product.title} rest." }, status: :ok
  end

  def remove_product(order_product)
    order_product.destroy
    render json: { success: "#{order_product.product.title} removed from your order." }, status: :ok
  end
end
