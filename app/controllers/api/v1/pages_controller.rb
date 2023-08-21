require 'cloudinary'

class Api::V1::PagesController < ApplicationController
  def home
    @products = Product.all
    @products = @products.where(category: params[:category]) if params[:category].present?
    @products = @products.where(vegetarian: params[:vegetarian]) if params[:vegetarian].present?
    @products = @products.order(price: params[:order]) if params[:order].present?

    respond_to do |format|
      format.html.haml
      format.json { render json: @products, each_serializer: ProductSerializer }
    end
  end
  
  def help; end

  def about; end

  def contact; end
end
