class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  
  def index
  end
  
  def show
  end
  
  def new
    @product = Product.new
  end
end
