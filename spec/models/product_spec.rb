require 'rails_helper'

RSpec.describe Product, type: :model do

  describe "Validations" do
    before(:each) do
      @category = Category.new(name:"Test")
      @category.save
    end

    it "saves a product with all fields" do
      @product = Product.new({
        name: "Plumbus", 
        price_cents: 9999, 
        quantity: 69, 
        category_id: @category[:id]})
      expect(@product).to be_valid
    end

    it "should validate name" do
      @product = Product.new({
        name: nil, 
        price: 99.99, 
        quantity: 69, 
        category_id: @category[:id]})
        expect(@product).to be_invalid
        expect(@product.errors.full_messages.include?("Name can't be blank")).to be_truthy

    end

    it "should validate price" do
      @product = Product.new({ 
        name: "Gumpus",
        price_cents: nil,
        quantity: 69,
        category_id: @category[:id]})
        expect(@product).to be_invalid
        expect(@product.errors.full_messages.include?("Price cents is not a number")).to be_truthy
      end

    it "should validate quantity" do
      @product = Product.new({
        name: "Plumbus", 
        price: 9999,
        quantity: nil, 
        category_id: @category[:id]})
        expect(@product).to be_invalid
        expect(@product.errors.full_messages.include?("Quantity can't be blank")).to be_truthy
    end

    it "should validate category" do
      @product = Product.new({
        name: "Gloopnik", 
        price_cents: 9999, 
        quantity: 69, 
        category_id: nil})
        expect(@product).to be_invalid
        expect(@product.errors.full_messages.include?("Category can't be blank")).to be_truthy
    end
  end
end