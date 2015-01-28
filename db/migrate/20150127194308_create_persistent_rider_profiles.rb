class CreatePersistentRiderProfiles < ActiveRecord::Migration
  def change
    create_table :persistent_rider_profiles do |t|
      t.references :user
      t.text :bio

      t.timestamps
    end
  end
end
