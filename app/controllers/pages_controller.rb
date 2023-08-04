class PagesController < ApplicationController
  def home
    if params[:category] == 'entree'
      @products = Product.where(category: 0)
    elsif params[:category] == 'second_course'
      @products = Product.where(category: 1)
    elsif params[:category] == 'salad'
      @products = Product.where(category: 2) 
    elsif params[:category] == 'pizza'
      @products = Product.where(category: 3)
    elsif params[:category] == 'dessert'
      @products = Product.where(category: 4)
    else
      @products = Product.all
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
