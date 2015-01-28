class CreateRideYears < ActiveRecord::Migration
  def change
    create_table :ride_years do |t|
      t.integer :registration_fee
      t.integer :min_fundraising_goal
      t.integer :year
      t.date :ride_start_date
      t.date :ride_end_date
      t.integer :current, :default => 0

      t.timestamps
    end
  end
end
