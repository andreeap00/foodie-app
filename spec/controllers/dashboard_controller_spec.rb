require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  describe '#mark_as_handled' do
    let!(:user) { User.create(name: 'Itachi Uchiha', email: 'itachi.uchiha@yahoo.com', password: 'Password1!', role: :admin) }
    let!(:order) { Order.create(user: user, status: :pending) }

    before do
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:logged_in?).and_return(true)
      authorize_admin=true
    end

    it 'sets order status completed and redirects to admin dashboard' do
      put :mark_as_handled, params: { order_id: order.id }
      order.reload
      expect(order.status).to eq('completed')
      expect(flash[:success]).to eq("Order marked as ready for delivery.")
      expect(response).to redirect_to(admin_dashboard_path)
    end

    it 'error flash message if order update fails and redirects to admin dashboard' do
      allow_any_instance_of(Order).to receive(:update).and_return(false)
      put :mark_as_handled, params: { order_id: order.id }
      expect(flash[:error]).to eq("Failed to mark the order.")
      expect(response).to redirect_to(admin_dashboard_path)
    end
  end
end
