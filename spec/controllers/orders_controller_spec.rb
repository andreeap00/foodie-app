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
end
