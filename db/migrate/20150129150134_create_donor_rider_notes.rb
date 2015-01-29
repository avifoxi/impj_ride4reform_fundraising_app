class CreateDonorRiderNotes < ActiveRecord::Migration
  def change
    create_table :donor_rider_notes do |t|
      t.references :rider_year_registration, index: true
      t.references :receipt, index: true
      t.boolean :visible_to_public, default: true
      t.text :note_to_rider

      t.timestamps
    end
  end
end
