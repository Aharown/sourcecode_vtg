class Garment < ApplicationRecord
  belongs_to :category
  serialize :cloudinary_photos, Array
  attribute :price, default: 0.0
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
  before_validation :set_default_stock_quantity, on: :create


  def sold?
    sold
  end

  private

  def set_default_stock_quantity
    self.stock_quantity ||= 1
  end
end
