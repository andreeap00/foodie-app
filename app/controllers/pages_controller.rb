class PagesController < ApplicationController
  def home
    @products = Product.all

    if params[:category] == 'entree'
      @products = @products.where(category: 0)
    elsif params[:category] == 'second_course'
      @products = @products.where(category: 1)
    elsif params[:category] == "salad"
      @products = @products.where(category: 2)
    elsif params[:category] == "pizza"
      @products = @products.where(category: 3)
    elsif params[:category] == "dessert"
      @products = @products.where(category: 4)
    end

    if params[:vegetarian] == 'non_vegetarian'
      @products = @products.where(vegetarian: 0)
    elsif params[:vegetarian] == 'vegetarian'
      @products = @products.where(vegetarian: 1)
    end

    if params[:order] == 'descending'
      @products = @products.order(price: :desc)
    else params[:order] == 'ascending'
      @products = @products.order(:price)
    end

        # @products_entree_vegetarian = Product.where(category: 0, vegetarian: 1)
    # @products_entree_non_vegetarian = Product.where(category: 0, vegetarian: 0)
    # @products_second_course_vegetarian = Product.where(category: 1, vegetarian: 1)
    # @products_second_course_non_vegetarian = Product.where(category: 1, vegetarian: 0)
    # @products_salad_vegetarian = Product.where(category: 2, vegetarian: 1)
    # @products_salad_non_vegetarian = Product.where(category: 2, vegetarian: 0)
    # @products_pizza_vegetarian = Product.where(category: 3, vegetarian: 1)
    # @products_pizza_non_vegetarian = Product.where(category: 3, vegetarian: 0)
    # @products_dessert_vegetarian = Product.where(category: 4, vegetarian: 1)
    # @products_dessert_non_vegetarian = Product.where(category: 4, vegetarian: 0)

    # @products = @products_entree_vegetarian.or(@products_entree_non_vegetarian).or(@products_second_course_vegetarian).or(@products_second_course_non_vegetarian).or(@products_salad_vegetarian).or(@products_salad_non_vegetarian).or(@products_pizza_non_vegetarian).or(@products_pizza_vegetarian).or(@products_dessert_non_vegetarian).or(@products_dessert_vegetarian)
    # @products = Product.all
    # @products = Product.where(category: 0) if params[:category] == 'entree'
    # @products = Product.where(category: 1) if params[:category] == 'second_course'      
    # @products = Product.where(category: 2)  if params[:category] == 'salad'      
    # @products = Product.where(category: 3) if params[:category] == 'pizza'      
    # @products = Product.where(category: 4) if params[:category] == 'dessert'
    # @products = Product.order(:price)    
    # @products = Product.where(vegetarian: 0) if params[:vegetarian] == 'non_vegetarian'
    # @products = Product.where(vegetarian: 1) if params[:vegetarian] == 'vegetarian'
  end

  def help
  end

  def about
  end

  def contact
  end
end
