class Api::V1::PagesController < Api::V1::ApplicationController
  skip_before_action :authenticate, only: [:home]

  def home
    products = Product.all
    products = products.where(category: params[:category]) if params[:category].present?
    products = products.where(vegetarian: params[:vegetarian]) if params[:vegetarian].present?
    products = products.order(price: params[:order]) if params[:order].present?

    render json: products
  end

  def help; end

  def about; end

  def contact; end
end
