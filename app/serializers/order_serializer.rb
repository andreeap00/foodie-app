class OrderSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :status

  has_many :order_products
end
