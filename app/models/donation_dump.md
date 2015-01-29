class DonationSpec < ActiveRecord::Base
  belongs_to :rider_year_registration
  has_one :rider, through: :rider_year_registration, source: :user
  
  belongs_to :receipt
  has_one :donor, through: :receipt, source: :user

  validates_associated :receipt, on: :create
  validates_associated :rider_year_registration, on: :create
end

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
