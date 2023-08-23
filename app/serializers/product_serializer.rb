class ProductSerializer < ActiveModel::Serializer
  include Cloudinary::Rails::UrlHelper

  attributes :id, :title, :description, :price, :category, :vegetarian, :image_url, :is_archived

  def image_url
    if object.image.attached?
      cl_image_path(object.image.key)
    end
  end

  has_many :order_products
end
