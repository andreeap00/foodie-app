class PagesController < ApplicationController
  def home
    @products = Product.all
    @products = @products.where(category: params[:category]) if params[:category].present?
    @products = @products.where(vegetarian: params[:vegetarian]) if params[:vegetarian].present?
    @products = @products.order(price: params[:order]) if params[:order].present?
  end

  def help; end

  def about; end

  def contact; end
end
