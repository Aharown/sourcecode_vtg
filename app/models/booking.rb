class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :garment
  belongs_to :reviews
end
