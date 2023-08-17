require 'rails_helper'

RSpec.describe Admin::ProductsController, type: :controller do
  let!(:user) { User.create(name: 'Itachi Uchiha', email: 'itachi.uchihaa@yahoo.com', password: 'Password1!', role: :admin) }
  let!(:order) { Order.create(user: user, status: :pending) }
  let(:product_params) { { title: 'New Product', description: 'Product description', price: 9.99, category: :entree, vegetarian: :vegetarian } }

  describe '#show' do
    it 'renders show template' do
      product = Product.create(product_params)
      get :show, params: { id: product.id }
      expect(response).to render_template(:show)
    end
  end

  describe '#new' do
    before do
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:logged_in?).and_return(true)
    end

    it 'renders new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe '#create' do
    before do
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:logged_in?).and_return(true)
    end

    context 'with acceptable parameters' do
      it 'creates new product' do
        expect {
          post :create, params: { product: product_params }
        }.to change(Product, :count).by(1)
      end

      it 'redirects to product show view' do
        post :create, params: { product: product_params }
        expect(response).to redirect_to(admin_product_path(Product.last))
      end
    end

    context 'with invalid parameters' do
      it 'renders new template' do
        post :create, params: { product: { title: '' } }
        expect(response).to render_template(:new)
      end
    end
  end
end
