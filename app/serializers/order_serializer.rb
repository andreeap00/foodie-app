class OrderSerializer < ApplicationSerializer
  attributes :id, :user_id, :status

  has_many :order_products

  attribute :created_at do |object|
    object.created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
