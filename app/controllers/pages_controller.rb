class PagesController < ApplicationController
  def home
    @products = Product.all
    
    @products = @products.where(category: :entree) if params[:category] == "entree"
    @products = @products.where(category: :second_course) if params[:category] == "second_course"
    @products = @products.where(category: :salad) if params[:category] == "salad"
    @products = @products.where(category: :pizza) if params[:category] == "pizza"
    @products = @products.where(category: :dessert) if params[:category] == "dessert"

    @products = @products.order(:price) if params[:order] == "asc"
    @products = @products.order(price: :desc) if params[:order] == "desc"

    @products = @products.where(vegetarian: :non_vegetarian) if params[:vegetarian] == "non_vegetarian"
    @products = @products.where(vegetarian: :vegetarian) if params[:vegetarian] == "vegetarian"
  end

  def help
  end

  def about
  end

  def contact
  end
end
