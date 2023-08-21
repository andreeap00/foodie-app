class OrderProductSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :product_id
end
