class DropBookingsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :bookings, force: :cascade
  end
end
