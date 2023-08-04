class ProductsController < ApplicationController
  def index
    @entree_products = Product.where(category: 0)
    @second_course_products = Product.where(category: 1)
    @salad_products = Product.where(category: 2)
    @pizza_products = Product.where(category: 3)
    @dessert_products = Product.where(category: 4)
  end
  
  def show
  end
  
  def new
    @product = Product.new
  end
end
