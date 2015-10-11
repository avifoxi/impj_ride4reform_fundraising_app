class DiscountCodeValidator < ActiveModel::Validator
  def validate( record )
    custom = record.custom_ride_option
    unless custom
    	return record.errors[:custom_ride_option] << 'That is an invalid custom option.'
    end
    unless custom.correct_discount_code?( record )
    	record.errors[:discount_code] << 'The discount code is not valid. Check again and resubmit.'
    end
  end
end