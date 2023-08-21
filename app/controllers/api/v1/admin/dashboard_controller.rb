class Api::V1::Admin::DashboardController < ApplicationController
  before_action :authorize_admin

  def index
    orders = Order.where.not(status: :cart)
                  .where.not(created_at: nil)
                  .order(created_at: :desc)
                  .includes(:user)
                  .group_by(&:user)

    pending_orders = orders.where(status: :pending)
    completed_orders = orders.where(status: :completed)
    delivered_orders = orders.where(status: :delivered)

    orders_by_user = pending_orders.merge(completed_orders) { |user, pending, completed| pending + completed }
    orders_by_user = orders_by_user.merge(delivered_orders) { |user, pc_orders, delivered| pc_orders + delivered }

    render json: { orders_by_user: orders_by_user }
  end

  def mark_as_handled
    @order = Order.find(params[:order_id])
    if @order.update(status: :completed)
      render json: { message: "Order marked as ready for delivery." }
    else
      render json: { error: "Failed to mark the order." }, status: :unprocessable_entity
    end
  end

  def mark_as_delivered
    @order = Order.find(params[:order_id])
    if @order.update(status: :delivered)
      render json: { message: "Order marked as delivered." }
    else
      render json: { error: "Failed to mark order as delivered." }, status: :unprocessable_entity
    end
  end
 
  private
    
  def authorize_admin
    render json: { error: "You are not authorized to access this page." }, status: :unauthorized unless current_user.admin?
  end
end
