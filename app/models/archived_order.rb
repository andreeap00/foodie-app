class ArchivedOrder < ApplicationRecord
  has_many :archived_order_products
  has_many :archived_products, through: :archived_order_products
end
