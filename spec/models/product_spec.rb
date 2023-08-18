require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it 'validates title presence' do
      product = Product.new(price: 25.49, vegetarian: :non_vegetarian, category: :entree) 
      expect(product).not_to be_valid
      expect(product.errors[:title]).to include("can't be blank")
    end

    it 'validates price value >= 0' do
        product = Product.new(title: 'The Most Delicious Pizza Ever', price: -90)
        expect(product).not_to be_valid
        expect(product.errors[:price]).to include("must be greater than or equal to 0")
    end

    it 'validates price presence' do
      product = Product.new(title: 'The Most Delicious Dessert Ever')
      expect(product).not_to be_valid
      expect(product.errors[:price]).to include("can't be blank")
    end

    it 'validates acceptable attributes' do
      product = Product.new(title: 'The Most Delicious Salad Ever', price: 50.33, description: "Salads", vegetarian: :vegetarian, category: :entree)
      expect(product).to be_valid
    end
  end

  describe 'enums' do
    it 'gets enum for vegetarian with its corresponding values' do
      enum_values = described_class.defined_enums['vegetarian']
      expect(enum_values).to eq({ 'non_vegetarian' => 0, 'vegetarian' => 1 })
    end
  end

  describe 'enums' do
    it 'gets enum for category with its corresponding values' do
      enum_values = described_class.defined_enums['category']
      expect(enum_values).to eq({ 'entree' => 0, 'second_course' => 1, 'salad' => 2, 'pizza' => 3, 'dessert' => 4 })
    end
  end
end
