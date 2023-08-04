class PagesController < ApplicationController
  def home
    @products = Product.all

      @products.each do |product|
        if product.image.attached?
          puts "Product with ID #{product.id} has an attached image."
        else
          puts "Product with ID #{product.id} does not have an attached image."
        end
      end
  end

  def help
  end

  def about
  end

  def contact
  end
end
