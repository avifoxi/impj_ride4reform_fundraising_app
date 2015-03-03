class CreateRiderYearRegistrations < ActiveRecord::Migration
  def change
    create_table :rider_year_registrations do |t|
      t.references :ride_year, index: true
      t.references :user, index: true
      t.integer :goal
      t.integer :raised, default: 0
      t.boolean :agree_to_terms
      t.string :ride_option
      t.references :receipt

      t.timestamps
    end
  end
end
