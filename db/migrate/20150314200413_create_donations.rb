class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.boolean :anonymous_to_public, default: false
      t.text :note_to_rider
      t.references :rider_year_registration, index: true
      t.references :receipt, index: true
      t.references :ride_year, index: true
      t.references :user
      t.integer :amount
      t.boolean :fee_is_processed, default: false
      t.boolean :is_organizational, default: false

      t.timestamps
    end
  end
end
