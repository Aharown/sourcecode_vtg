require 'rails_helper'

RSpec.describe Garment, type: :model do
  it "is valid with required attributes" do
    category = Category.create(name: "Jackets") 
    product = Garment.new(
      title: "Vintage Jacket",
      price: 5000,
      stock_quantity: 1,
      category: category
    )
    expect(product).to be_valid
  end

  it "is invalid without a name" do
    product = Garment.new(price: 5000)
    expect(product).to be_invalid
  end
end
