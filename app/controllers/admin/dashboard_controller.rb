class Admin::DashboardController < ApplicationController
  before_action :authorize_admin

  def index
    # left this here for eventual further adjustments
    # @orders_by_user = Order
    #                   .where.not(status: :cart)
    #                   .where.not(created_at: nil)
    #                   .where(status: [Order.statuses[:pending], Order.statuses[:completed], Order.statuses[:delivered]])
    #                   .order(status: :asc, created_at: :desc)
    #                   .includes(:user)
    #                   .group_by(&:user)

    pending_orders = Order
                .where.not(status: :cart)
                .where.not(created_at: nil)
                .where(status: Order.statuses[:pending])
                .order(created_at: :desc)
                .includes(:user)
                .group_by(&:user)

    completed_orders = Order
                      .where.not(status: :cart)
                      .where.not(created_at: nil)
                      .where(status: Order.statuses[:completed])
                      .order(created_at: :desc)
                      .includes(:user)
                      .group_by(&:user)
    delivered_orders = Order
                    .where.not(status: :cart)
                    .where.not(created_at: nil)
                    .where(status: Order.statuses[:delivered])
                    .order(created_at: :desc)
                    .includes(:user)
                    .group_by(&:user)

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
      redirect_to root_path, alert: "You are not authorized to access this page." unless current_user.admin?
    end
end
