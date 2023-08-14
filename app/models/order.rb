class Order < ApplicationRecord
  belongs_to :user
  has_many :order_products

  enum status: { cart: 0, pending: 1, completed: 2, delivered: 3 }
end
