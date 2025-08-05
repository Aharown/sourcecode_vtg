class Garment < ApplicationRecord
  belongs_to :category
  serialize :cloudinary_photos, Array, coder: JSON
  attr_accessor :cloudinary_photos_raw
  attribute :price, default: 0.0
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
  before_validation :set_default_stock_quantity, on: :create
  before_validation :parse_cloudinary_photos_raw

  def sold?
    sold
  end

  private

  def set_default_stock_quantity
    self.stock_quantity ||= 1
  end

  def parse_cloudinary_photos_raw
    return if cloudinary_photos_raw.blank?

    input = cloudinary_photos_raw.strip

 
    if (input.start_with?('[') && input.end_with?(']'))
      begin
        parsed = JSON.parse(input)
        if parsed.is_a?(Array)
          self.cloudinary_photos = parsed.map(&:to_s).map(&:strip).reject(&:blank?)
          return
        end
      rescue JSON::ParserError

      end


      input = input[1..-2]
    end

    self.cloudinary_photos = input.split(',').map(&:strip).reject(&:blank?)
  end
end
