require 'rails_helper'

RSpec.describe Api::V1::Admin::DisplayUsersController, type: :request do
  describe 'GET /api/v1/admin/display_users' do
    let!(:admin_user) { User.create(name: 'Admin', email: 'admin@yahoo.com', password: 'Password1!', role: 'admin') }
    let!(:user1) { User.create(name: 'User 1', email: 'user1@yahoo.com', password: 'Password1!', role: 'user') }
    let!(:user2) { User.create(name: 'User 2', email: 'user2@yahoo.com', password: 'Password1!', role: 'user') }
    let(:admin_token) { JWT.encode({ user_id: admin_user.id, exp: Time.now.to_i + 3600 }, ENV['JWT_SECRET_KEY'], 'HS256') }
    let(:user_token) { JWT.encode({ user_id: user1.id, exp: Time.now.to_i + 3600 }, ENV['JWT_SECRET_KEY'], 'HS256') }

    it "returns users only for admin" do
      headers = { 'Authorization' => "Bearer #{admin_token}" }
      get "/api/v1/admin/display_users", headers: headers

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body.length).to eq(2)

      puts "JSON Response:"
      puts JSON.pretty_generate(response_body)
    end

    it "returns unauthorized for non-admin users" do
      headers = { 'Authorization' => "Bearer #{user_token}" }
      get "/api/v1/admin/display_users", headers: headers

      expect(response).to have_http_status(:unauthorized)
      response_body = JSON.parse(response.body)
      expect(response_body['error']).to eq('You are not authorized to access this page.')

      puts "JSON Response:"
      puts JSON.pretty_generate(response_body)
    end
  end
end
