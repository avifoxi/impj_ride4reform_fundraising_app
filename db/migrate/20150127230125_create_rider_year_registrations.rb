class CreateRiderYearRegistrations < ActiveRecord::Migration
  def change
    create_table :rider_year_registrations do |t|
      t.references :ride_year, index: true
      t.references :user, index: true
      t.integer :goal
      t.boolean :agree_to_terms
      t.string :ride_option
      t.references :registration_payment_receipt
      t.boolean :active_for_fundraising, default: true
      t.references :custom_ride_option

      t.timestamps
    end
  end
end
