class CreateCustomRideOptions < ActiveRecord::Migration
  def change
    create_table :custom_ride_options do |t|
      t.string :display_name
      t.text :description
      t.text :liability_text
      t.date :start_date
      t.date :end_date
      t.string :discount_code
      t.date :registration_cutoff
      t.integer :registration_fee
      t.references :ride_year, index: true
      t.boolean :is_disabled, default: false
      t.timestamps
    end
  end
end
