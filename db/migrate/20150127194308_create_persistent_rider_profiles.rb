class CreatePersistentRiderProfiles < ActiveRecord::Migration
  def change
    create_table :persistent_rider_profiles do |t|
      t.references :user
      t.text :bio

      t.string :primary_phone
      t.string :secondary_phone

      t.timestamps
    end
  end
end
