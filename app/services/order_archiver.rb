class OrderArchiver
    
  def self.archive_orders_and_products
    Order.all.each do |order|
      archived_order = ArchivedOrder.create(
        created_at: order.created_at,
        updated_at: order.updated_at,
        status: order.status
      )
      
      order.order_products.each do |order_product|
        archived_product = ArchivedProduct.create(
          title: order_product.product.title,
          description: order_product.product.description,
          price: order_product.product.price,
          category: order_product.product.category,
          vegetarian: order_product.product.vegetarian
        )
      
      ArchivedOrderProduct.create(
        archived_order: archived_order,
        archived_product: archived_product
      )
      end
      archived_order.save(validate: false)
    end
  end
end
