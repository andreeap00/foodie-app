class Api::V1::OrdersController < ApplicationController
  # before_action :logged_in_user, only: [:show, :purchase, :add_to_order, :remove_from_order]
  # before_action :correct_user, only: [:update, :destroy]
  before_action :authenticate, only: [:show, :purchase, :add_to_order, :remove_from_order]
  before_action :correct_user, only: [:update, :destroy]

  def show
    @order = current_user.orders.find(params[:id])
    if @order
      @order_products = @order.order_products.includes(:product)
      render json: { order: @order, order_products: @order_products }
    else
      render json: { error: 'Order not found' }, status: :not_found
    end
  end

  def purchase
    @order = current_user.orders.find(params[:id])
    if @order.present?
      if @order.update(status: 'pending')
        render json: { message: 'Order successfully purchased' }
      else
        render json: { error: 'Purchasing products not accomplished' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Order not found' }, status: :not_found
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
      render json: { message: "#{product.title} successfully added to cart" }
    else
      render json: { error: "#{product.title} not added to cart" }, status: :unprocessable_entity
    end
  end

  def remove_from_order
    @order = current_user.orders.find_or_create_by(status: 'cart')
    product = Product.find(params[:product_id])
    order_product = @order.order_products.find_by(product: product)

    unless order_product.present?
      render json: { error: "#{product.title} not found in the cart" }, status: :not_found
      return
    end

    if order_product.quantity > 1
      decrease_quantity(order_product)
    else
      remove_product(order_product)
    end

    render json: { message: "#{order_product.product.title} updated in the cart" }
  end

  private

  def decrease_quantity(order_product)
    order_product.quantity -= 1
    order_product.save
  end

  def remove_product(order_product)
    order_product.destroy
  end
end
