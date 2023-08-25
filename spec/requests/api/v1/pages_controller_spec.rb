require 'rails_helper'

RSpec.describe Api::V1::PagesController, type: :request do
  describe 'GET /api/v1/home' do
    it "returns a list of products" do
      product1 = Product.create(title: 'Pizza', price: 20, category: 'pizza', vegetarian: :vegetarian)
      product2 = Product.create(title: 'Burger', price: 15, category: 'second_course', vegetarian: :vegetarian)

      get "/api/v1/home", params: { category: 'pizza', vegetarian: :vegetarian }, headers: {}
      
      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body.length).to eq(1)
      expect(response_body[0]['title']).to eq(product1.title)
    end
  end
end
