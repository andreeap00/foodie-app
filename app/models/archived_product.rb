class ArchivedProduct < ApplicationRecord
  has_many :archived_order_products
  has_many :archived_orders, through: :archived_order_products
end
