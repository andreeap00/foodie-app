class Api::V1::Admin::DashboardController < Api::V1::ApplicationController
  include AdminAuthorization
  
  def index
    orders = Order.where.not(status: :cart)
                   .where.not(created_at: nil)
                   .order(status_order: :asc, created_at: :desc)
                   .includes(:user)
                   .select(
                     <<-SQL
                       *,
                       CASE
                         WHEN status = #{Order.statuses['pending']} THEN 1
                         WHEN status = #{Order.statuses['completed']} THEN 2
                         WHEN status = #{Order.statuses['delivered']} THEN 3
                       END AS status_order
                     SQL
                   )
    render json: orders
  end

  def mark_as_handled
    order = Order.find(params[:order_id])
    if order.pending?
      if order.update(status: :completed)
        render json: { message: "Order marked as ready for delivery." }, status: :ok
      else
        render json: { error: "Failed to mark the order." }, status: :unprocessable_entity
      end
    else
      render json: { error: "Only pending orders can be handled." }, status: :unprocessable_entity
    end
  end

  def mark_as_delivered
    order = Order.find(params[:order_id])
    if order.completed?
      if order.update(status: :delivered)
        render json: { message: "Order marked as delivered." }, status: :ok
      else
        render json: { error: "Failed to mark order as delivered." }, status: :unprocessable_entity
      end
    else
      render json: { error: "Only completed orders can be delivered." }, status: :unprocessable_entity
    end
  end
end
