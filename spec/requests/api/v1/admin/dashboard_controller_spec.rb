require 'rails_helper'

RSpec.describe Api::V1::Admin::DashboardController, type: :request do
  let!(:admin_user) { User.create(name: 'Admin', email: 'admin@yahoo.com', password: 'Password1!', role: 'admin') }
  let!(:user1) { User.create(name: 'User 1', email: 'user1@yahoo.com', password: 'Password1!', role: 'user') }

  let(:admin_token) { JWT.encode({ user_id: admin_user.id, exp: Time.now.to_i + 3600 }, ENV['JWT_SECRET_KEY'], 'HS256') }
  let(:user_token) { JWT.encode({ user_id: user1.id, exp: Time.now.to_i + 3600 }, ENV['JWT_SECRET_KEY'], 'HS256') }

  describe 'GET /api/v1/admin/dashboard' do
    it "returns orders for admin" do
      headers = { 'Authorization' => "Bearer #{admin_token}" }
      order1 = Order.create(user: user1, status: 'pending')
      order2 = Order.create(user: user1, status: 'completed')
      get "/api/v1/admin/dashboard", headers: headers

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body.length).to eq(2)
    end

    it "returns unauthorized for non-admin users" do
      headers = { 'Authorization' => "Bearer #{user_token}" }
      get "/api/v1/admin/dashboard", headers: headers

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'PATCH /api/v1/admin/mark_as_handled/:order_id' do
    it "marks order as handled" do
      headers = { 'Authorization' => "Bearer #{admin_token}" }
      order = Order.create(user: user1, status: 'pending')

      patch "/api/v1/admin/dashboard/mark_as_handled/#{order.id}", headers: headers

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body['message']).to eq('Order marked as ready for delivery.')
      expect(order.reload.status).to eq('completed')

      puts "JSON Response:"
      puts JSON.pretty_generate(response_body)
    end

    it "returns error for non-pending orders" do
      headers = { 'Authorization' => "Bearer #{admin_token}" }
      order = Order.create(user: user1, status: 'completed')

      patch "/api/v1/admin/dashboard/mark_as_handled/#{order.id}", headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      response_body = JSON.parse(response.body)
      expect(response_body['error']).to eq('Only pending orders can be handled.')
      expect(order.reload.status).to eq('completed')

      puts "JSON Response:"
      puts JSON.pretty_generate(response_body)
    end
  end

  describe 'PATCH /api/v1/admin/dashboard/mark_as_delivered/:order_id' do
    it "marks order as delivered" do
      headers = { 'Authorization' => "Bearer #{admin_token}" }
      order = Order.create(user: user1, status: 'completed')

      patch "/api/v1/admin/dashboard/mark_as_delivered/#{order.id}", headers: headers

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body['message']).to eq('Order marked as delivered.')
      expect(order.reload.status).to eq('delivered')

      puts "JSON Response:"
      puts JSON.pretty_generate(response_body)
    end

    it "returns error for non-completed orders" do
      headers = { 'Authorization' => "Bearer #{admin_token}" }
      order = Order.create(user: user1, status: 'pending')

      patch "/api/v1/admin/dashboard/mark_as_delivered/#{order.id}", headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      response_body = JSON.parse(response.body)
      expect(response_body['error']).to eq('Only completed orders can be delivered.')
      expect(order.reload.status).to eq('pending')

      puts "JSON Response:"
      puts JSON.pretty_generate(response_body)
    end
  end
end
