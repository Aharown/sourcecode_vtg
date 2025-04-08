class Garment < ApplicationRecord
  belongs_to :category
  has_many_attached :photos
  attribute :price, default: 0.0
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
  before_validation :set_default_stock_quantity, on: :create
  after_create :create_stripe_product_and_price


  def sold?
    sold
  end

  private

  def set_default_stock_quantity
    self.stock_quantity ||= 1
  end


  def create_stripe_product_and_price
    product = Stripe::Product.create({
      name: title,
      
    })

    price = Stripe::Price.create({
      product: product.id,
      unit_amount: price,
      currency: 'GBP'
    })

    update(price_id: price.id)
  end
end
