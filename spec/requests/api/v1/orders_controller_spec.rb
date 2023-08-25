require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :request do
  let!(:user) { User.create(name: 'Itachi Uchiha', email: 'itachi.uchiha@yahoo.com', password: 'Password1!') }
  let!(:product) { Product.create(title: 'Pizza', price: 35) }
  let!(:token) { JWT.encode({ user_id: user.id, exp: Time.now.to_i + 3600 }, ENV['JWT_SECRET_KEY'], 'HS256') }
  let!(:headers) {{ 'Authorization' => "Bearer #{token}" }}

  describe 'POST /api/v1/orders/:order_id/add_to_order/:product_id' do
    before do
      allow_any_instance_of(Api::V1::OrdersController).to receive(:current_user).and_return(user)
      allow_any_instance_of(Api::V1::OrdersController).to receive(:authenticate).and_return(true)
      allow_any_instance_of(Api::V1::OrdersController).to receive(:authorize_user).and_return(true)
    end

    it "adds product to order when user is authenticated" do
      order = user.orders.create(status: 'cart')
      expect {
        post "/api/v1/orders/#{order.id}/add_to_order/#{product.id}", headers: headers
      }.to change(OrderProduct, :count).by(1)

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body['success']).to eq("#{product.title} successfully added to cart.")
    end

    it "increases quantity of product type when already in the order" do
      order = user.orders.create(status: 'cart')
      order.order_products.create(product: product, quantity: 5)
      expect {
        post "/api/v1/orders/#{order.id}/add_to_order/#{product.id}", headers: headers
      }.not_to change(OrderProduct, :count)

      expect(product.order_products.reload.first.quantity).to eq(6)
    end

    it "responses to unsuccessfully addition to order" do
      allow_any_instance_of(OrderProduct).to receive(:save).and_return(false)
      order = user.orders.create(status: 'cart')
      post "/api/v1/orders/#{order.id}/add_to_order/#{product.id}", headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "POST /api/v1/orders/:order_id/remove_from_order/:product_id" do
    before do
      allow_any_instance_of(Api::V1::OrdersController).to receive(:current_user).and_return(user)
      allow_any_instance_of(Api::V1::OrdersController).to receive(:authenticate).and_return(true)
      allow_any_instance_of(Api::V1::OrdersController).to receive(:authorize_user).and_return(true)
    end

    it "removes product from order when user is authenticated" do
      order = user.orders.create(status: 'cart')
      order_product = order.order_products.create(product: product, quantity: 1)
    
      expect {
        delete "/api/v1/orders/#{order.id}/remove_from_order/#{product.id}", headers: headers
      }.to change { order.order_products.reload.count }.by(-1)
      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body['success']).to eq("#{product.title} removed from your order.")
    end

    it "decreases number of products in order when user is authenticated" do
      order = user.orders.create(status: 'cart')
      order_product = order.order_products.create(product: product, quantity: 6)
      delete "/api/v1/orders/#{order.id}/remove_from_order/#{product.id}", headers: headers

      expect(order_product.reload.quantity).to eq(5)
      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body['success']).to eq("5 #{product.title} rest.")
    end
  end
end
