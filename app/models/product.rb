class Product < ApplicationRecord
  has_one_attached :image

  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  enum category: { entree: 0, second_course: 1, salad: 2, pizza: 3, dessert: 4 }
end
