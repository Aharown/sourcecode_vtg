class Garment < ApplicationRecord
  belongs_to :user
  has_many :bookings
  belongs_to :category
  has_many_attached :photos
  attribute :rental_price, default: 0.0
end
