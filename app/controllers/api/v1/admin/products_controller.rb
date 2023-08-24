class Admin::ProductsController < Api::V1::ApplicationController
  before_action :authorize_admin
  before_action :find_product, only: [:show, :update, :destroy]

  def show
    @product = Product.find(params[:id])
    render json: @product
  end

  def new
    @product = Product.new
    render json: @product
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      render json: @product, status: :created
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.update(is_archived: true)
      head :no_content
    else
      render json: { error: "Failed to archive product" }, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require.permit(:title, :description, :price, :category, :vegetarian, :image)
  end

  def find_product
    @product = Product.find(params[:id])
  end
end
