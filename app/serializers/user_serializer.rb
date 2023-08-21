class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :role

  has_many :orders, serializer: OrderSerializer
end