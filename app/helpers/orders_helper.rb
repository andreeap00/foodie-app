module OrdersHelper
  def calculate_order_total(order)
    total = 0
    order.order_products.each do |order_product|
      total += order_product.product.price * order_product.quantity
    end
    total
  end
end
