class CreateDonationSpecs < ActiveRecord::Migration
  def change
    create_table :donation_specs do |t|
      t.references :rider_year_registration, index: true
      t.references :receipt
      t.boolean :visible_to_public, default: true
      t.text :note_to_rider

      t.timestamps
    end
  end
end
