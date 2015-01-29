require 'rails_helper'

RSpec.describe Receipt, :type => :model do
	let(:receipt) { FactoryGirl.build(:receipt, :donation) }	

	it "has a valid factory" do
		expect(receipt).to be_an_instance_of(Receipt)
	end

	it "validates presence of paypal id and user" do 
		bad_rec = receipt.dup
		bad_rec.paypal_id = nil
		bad_rec.user = nil
		expect(bad_rec.save).to eq(false)
		expect(receipt.save).to eq(true)

	end

end
