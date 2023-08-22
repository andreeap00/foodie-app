class Admin::ProductsController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :admin_user, only: [:edit, :update]

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = 'Product created'
      redirect_to admin_product_path(@product)
    else
      render 'new'
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      flash[:success] = "Product updated"
      redirect_to admin_product_path(@product)
    else
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.update(is_archived: true)
      flash[:success] = "Product archived"
    else
      flash[:error] = "Failed to archive product"
    end
    redirect_to home_path
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :price, :category, :vegetarian, :image)
  end

  def logged_in_user
    if !logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
    end
  end

  def admin_user
    if current_user.nil? && !current_user.admin?
      flash[:danger] = "You don't have permission to perform this action."
      redirect_to home_path
    end
  end
end
