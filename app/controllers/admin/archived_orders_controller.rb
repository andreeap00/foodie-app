class Admin::ArchivedOrdersController < ApplicationController
  def index
    @archived_orders = ArchivedOrder.all
  end

  def show
    @archived_order = ArchivedOrder.find(params[:id])
    @archived_order_products = @archived_order.archived_order_products
    @archived_products = @archived_order_products.map(&:archived_product)
  end

  def archive_orders
    OrderArchiver.archive_orders_and_products
    redirect_to admin_archived_orders_path, notice: "Orders and products have been archived."
  end
end
