class Api::V1::Admin::DashboardController < Api::V1::ApplicationController
  include AdminAuthorization

  def index
    orders = Order.where.not(status: :cart)
              .where.not(created_at: nil)
              .order(created_at: :desc)
              .includes(:user)

    pending_orders = orders.select { |order| order.status == "pending" }
    completed_orders = orders.select { |order| order.status == "completed" }
    delivered_orders = orders.select { |order| order.status == "delivered" }
    @orders = pending_orders + completed_orders + delivered_orders

    render json: @orders
  end

  def mark_as_handled
    @order = Order.find(params[:order_id])
    if @order.update(status: :completed)
      render json: { message: "Order marked as ready for delivery." }, status: :ok
    else
      render json: { error: "Failed to mark the order." }, status: :unprocessable_entity
    end
  end

  def mark_as_delivered
    @order = Order.find(params[:order_id])
    if @order.update(status: :delivered)
      render json: { message: "Order marked as delivered." }, status: :ok
    else
      render json: { error: "Failed to mark order as delivered." }, status: :unprocessable_entity
    end
  end
end
