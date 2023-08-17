class Admin::ArchivedOrderProductsController < ApplicationController
  def index
    @archived_order = ArchivedOrder.find(params[:archived_order_id])
    @archived_order_products = @archived_order.archived_order_products
  end
end
