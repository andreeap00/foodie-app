class Api::V1::Admin::ProductsController < ApplicationController
  before_action :authenticate_admin

  def show
    @product = Product.find(params[:id])
    render json: @product
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      render json: { message: 'Product created', product: @product }, status: :created
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      render json: { message: 'Product updated', product: @product }
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.update(is_archived: true)
      render json: { message: 'Product archived' }
    else
      render json: { error: 'Failed to archive product' }, status: :unprocessable_entity
    end
  end

  private

    def product_params
      params.require(:product).permit(:title, :description, :price, :category, :vegetarian, :image)
    end

    def authenticate_admin
      render json: { error: "You don't have permission to perform this action." }, status: :unauthorized if current_user.nil? && !current_user&.admin?
    end
end
