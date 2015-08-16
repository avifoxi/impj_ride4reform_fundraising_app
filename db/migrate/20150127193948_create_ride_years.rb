class CreateRideYears < ActiveRecord::Migration
  def change
    create_table :ride_years do |t|
      t.integer :registration_fee
      t.integer :registration_fee_early
      t.integer :min_fundraising_goal
      t.integer :year
      t.date :ride_start_date
      t.date :ride_end_date
      t.date :early_bird_cutoff
      t.integer :current, :default => 0
      t.boolean :disable_public_site, default: true

      t.string :rabbinic_discount_code
      t.date :rabbinic_discount_

      t.timestamps
    end
  end
end
