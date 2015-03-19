MODEL

class DonorRiderNote < ActiveRecord::Base
  belongs_to :rider_year_registration
  has_one :rider, through: :rider_year_registration, source: :user

  belongs_to :receipt
  has_one :donor, through: :receipt, source: :user

  validates_associated :receipt, on: :create
  validates_associated :rider_year_registration, on: :create
end

MIGRATION

class CreateDonorRiderNotes < ActiveRecord::Migration
  def change
    create_table :donor_rider_notes do |t|
      t.references :rider_year_registration, index: true
      t.references :receipt, index: true
      t.boolean :anonymous_to_public, default: true
      t.text :note_to_rider

      t.timestamps
    end
  end
end

factory

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :donor_rider_note do
    anonymous_to_public true
    note_to_rider "I donate to you for riding your bike"
  
    association :rider_year_registration, factory: [:rider_year_registration, :with_valid_associations]
    association :receipt, factory: [:receipt, :donation]
  end
end

model spec
require 'rails_helper'

RSpec.describe DonorRiderNote, :type => :model do

	let(:drn) { FactoryGirl.build(:donor_rider_note)}

	it "has a valid factory" do
		expect( drn ).to be_an_instance_of(DonorRiderNote)
	end

	it "correctly associates to aliased donor" do 
		expect(drn.donor.first_name).to eq("Donor")
	end

	it "correctly associates to aliased rider" do 
		expect(drn.rider.first_name).to eq("Rider")
	end
end

