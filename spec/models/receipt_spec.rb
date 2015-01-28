require 'rails_helper'

RSpec.describe Receipt, :type => :model do
	let(:receipt) { FactoryGirl.build(:receipt) }	

	it "has a valid factory" do
		expect(receipt).to be_an_instance_of(Receipt)
	end

	it "validates presence of paypal id" do 
		bad_rec = receipt.dup
		bad_rec.paypal_id = nil
		expect(bad_rec.save).to eq(false)
		expect(receipt.save).to eq(true)

	end

end
