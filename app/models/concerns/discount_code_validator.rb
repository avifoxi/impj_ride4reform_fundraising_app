class DiscountCodeValidator < ActiveModel::Validator
  def validate( record )
    custom = CustomRideOption.find_by( display_name: record.ride_option )
    unless custom && record.ride_year.options.include?( record.ride_option )
    	return record.errors[:ride_option] << 'That is an invalid ride option.'
    end

    unless custom.correct_discount_code?( record )
    	record.errors[:discount_code] << 'The discount code is not valid. Check again and resubmit.'
    end
  end
end