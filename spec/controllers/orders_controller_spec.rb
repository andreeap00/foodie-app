require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:user) { User.create(name: 'Itachi Uchiha', email: 'itachi.uchiha@yahoo.com', password: 'Password1!') }
  let(:product) { Product.create(title: 'Pizza', price: 35) }
  
  describe "POST #add_to_order" do
    before do
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:logged_in?).and_return(true)
    end
    
    it "adds product to order when user is logged in" do
      expect {
        post :add_to_order, params: { id: user.id, product_id: product.id }
      }.to change(OrderProduct, :count).by(1)
      expect(flash[:success]).to be_present
      expect(flash[:success]).to eq("Pizza successfully added to cart.")
      expect(response).to redirect_to(order_path(user.orders.last))
    end

    it "increases quantity of product type when already in the order" do
        order = user.orders.create(status: 'cart')
        order.order_products.create(product: product, quantity: 5)
        expect {
          post :add_to_order, params: { id: user.id, product_id: product.id }
        }.not_to change(OrderProduct, :count)
  
        expect(product.order_products.reload.first.quantity).to eq(6)
      end
  end

  it "responses to unsuccessfully addition to order" do
    allow_any_instance_of(OrderProduct).to receive(:save).and_return(false)
    post :add_to_order, params: { id: user.id, product_id: product.id }
    expect(response).to redirect_to(login_path) 
  end

  describe "POST #remove_from_order" do
    before do
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:logged_in?).and_return(true)
    end

    it "removes product from order when user is logged in" do
      order = user.orders.create(status: 'cart')
      order_product = order.order_products.create(product: product, quantity: 1)
    
      expect {
        post :remove_from_order, params: { id: user.id, product_id: product.id }
      }.to change { order.order_products.reload.count }.by(-1)
      expect(flash[:success]).to eq("#{product.title} removed from your order.")
      expect(response).to redirect_to(order_path(user.orders.last))
    end

    it "decreases number of products in order when user is logged in" do
      order = user.orders.create(status: 'cart')
      order_product = order.order_products.create(product: product, quantity: 6)
      post :remove_from_order, params: { id: user.id, product_id: product.id }

      expect(order_product.reload.quantity).to eq(5)
      expect(flash[:success]).to eq("5 #{product.title} rest.")
      expect(response).to redirect_to(order_path(user.orders.last))
    end
  end
end
