class Api::V1::Admin::ProductsController < Api::V1::ApplicationController
  include AdminAuthorization
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
      render json: @product, status: :ok
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
    params.require(:product).permit(:title, :description, :price, :category, :vegetarian)
  end

  def find_product
    @product = Product.find(params[:id])
  end
end
