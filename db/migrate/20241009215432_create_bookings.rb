class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :garment, null: false, foreign_key: true
      t.integer :rental_period
      t.date :delivery_date
      t.integer :booking_price

      t.timestamps
    end
  end
end
