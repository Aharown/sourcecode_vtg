class Garment < ApplicationRecord
  belongs_to :category
  has_many_attached :photos
  attribute :price, default: 0.0

  def sold?
    sold 
  end
end
