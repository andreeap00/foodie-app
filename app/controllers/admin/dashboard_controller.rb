class Admin::DashboardController < ApplicationController
  before_action :authorize_admin

  def index
    orders = Order.where.not(status: :cart)
              .where.not(created_at: nil)
              .order(created_at: :desc)
              .includes(:user)
              .group_by(&:user)

    pending_orders = orders.transform_values { |user_orders| user_orders.select { |order| order.status == "pending" } }
    completed_orders = orders.transform_values { |user_orders| user_orders.select { |order| order.status == "completed" } }
    delivered_orders = orders.transform_values { |user_orders| user_orders.select { |order| order.status == "delivered" } }

    @orders_by_user = pending_orders.merge(completed_orders) { |user, pending, completed| pending + completed }
    @orders_by_user = @orders_by_user.merge(delivered_orders) { |user, pc_orders, delivered| pc_orders + delivered }
  end

  def mark_as_handled
    @order = Order.find(params[:order_id])
    if @order.update(status: :completed)
      flash[:success] = "Order marked as ready for delivery."
    else
      flash[:error] = "Failed to mark the order."
    end
    redirect_to admin_dashboard_path
  end

  def mark_as_delivered
    @order = Order.find(params[:order_id])
    if @order.update(status: :delivered)
      flash[:success] = "Order marked as delivered."
    else
      flash[:error] = "Failed to mark order as delivered."
    end
    redirect_to admin_dashboard_path
  end
 
  private
    
    def authorize_admin
      redirect_to root_path, alert: "You are not authorized to access this page." if !current_user.admin?
    end
end
