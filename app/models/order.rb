class Order < ApplicationRecord
  belongs_to :user
  has_many :order_products, dependent: :destroy

  enum status: { cart: 0, pending: 1, completed: 2, delivered: 3 }

  scope :active, -> { where(is_archived: false) }
  # scope :archived, -> { where(is_archived: true) }
end
