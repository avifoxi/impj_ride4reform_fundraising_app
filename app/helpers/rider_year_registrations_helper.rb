module RiderYearRegistrationsHelper

	def title_for_reg_payment(ryr)
		html = ''
		if ryr.custom_ride_option
			html << '<h3>Participants in ' + ryr.custom_ride_option.display_name + ' pay a registration rate of $' + ryr.custom_ride_option.registration_fee.to_s + '.</h3>'
		else
			html << '<h3>Every participant in the ride must pay a registration fee of $' + RideYear.current.registration_fee.to_s  + '. <br><small>Please complete this billing information to finish your registration!</small> </h3>'
		end
		html.html_safe
	end

	def correct_terms_for_ride_option(ryr)
  	html = ''
  	
  	case ryr.ride_option
			when 'Hiking'
				html << '<p>Disclaimer: Each participant agrees to examine any equipment supplied, at his/her own risk, and shall be in all respects responsible for his/her own safety. Each participant agrees that neither the Israel Movement for Reform and Progressive Judaism nor their employees or agents will be held responsible for any accidents, injury, death, loss or damage to personal affects, whatsoever.</p>
					<p>Fundraising: In order to participate in this event, you must raise the minimum sponsorship prior to March 2, 2015.  If you are unable to participate in the event for any reason, all donations received by you should nevertheless be sent to the Israel Movement for Reform and Progressive Judaism and will be allocated to the total sponsorship of the event. </p>
					<p>Age: Minimum age of entry is 18 unless accompanied by a parent or legal guardian in which case the minimum age is 17. A Parent or legal guardian must accompany minors at all times.</p>
					<p>Accommodation: Rooms will be shared wherever possible with someone of your choice – numbers per room will vary subject to location. Room standard is youth hostel, or better, when possible.</p>
					<p>The organizers reserve the right to change the route and/or accommodations should the necessity arise.</p>'
			when 'Hiking/Riding'
				html << '<p>Disclaimer: Each participant agrees to examine any equipment supplied, at his/her own risk, and shall be in all respects responsible for his/her own safety. Each participant agrees that neither the Israel Movement for Reform and Progressive Judaism nor their employees or agents will be held responsible for any accidents, injury, death, loss or damage to personal affects, whatsoever.</p>
					<p>Fundraising: In order to participate in this event, you must raise the minimum sponsorship prior to March 2, 2015.  If you are unable to participate in the event for any reason, all donations received by you should nevertheless be sent to the Israel Movement for Reform and Progressive Judaism and will be allocated to the total sponsorship of the event. </p>
					<p>Age: Minimum age of entry is 18 unless accompanied by a parent or legal guardian in which case the minimum age is 17. A Parent or legal guardian must accompany minors at all times.</p>
					<p>Accommodation: Rooms will be shared wherever possible with someone of your choice – numbers per room will vary subject to location. Room standard is youth hostel, or better, when possible.</p>
					<p>The organizers reserve the right to change the route and/or accommodations should the necessity arise.</p>'
			else
				html << "<p>Disclaimer: Each participant agrees to examine and use the bicycle and, where appropriate, any other equipment supplied, at his/her own risk, and shall be in all respects responsible for his/her own safety.  Each participant agrees that neither the Israel Movement for Reform and Progressive Judaism nor their employees or agents will be held responsible for any accidents, injury, death, loss or damage to personal affects, whatsoever.</p>
					<p>Fundraising: In order to participate in this event, you must raise the minimum sponsorship prior to March 2, 2015.  If you are unable to participate in the event for any reason, all donations received by you should nevertheless be sent to the Israel Movement for Reform and Progressive Judaism and will be allocated to the total sponsorship of the event. </p>
					<p>Age: Minimum age of entry is 18 unless accompanied by a parent or legal guardian in which case the minimum age is 17. A Parent or legal guardian must accompany minors at all times.</p>
					<p>Helmets: Must be worn for safety reasons during the ride.</p>
					<p>Accommodation: Rooms will be shared wherever possible with someone of your choice – numbers per room will vary subject to location. Room standard is youth hostel, or better, when possible.</p>
					<p>The organizers reserve the right to change the route and/or accommodations should the necessity arise.</p>"
		end
		html.html_safe
  end
end
