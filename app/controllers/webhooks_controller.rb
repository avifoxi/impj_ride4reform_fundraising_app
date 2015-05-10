class WebhooksController < ApplicationController
	skip_before_action :authenticate_admin!, :authenticate_user!

	protect_from_forgery :except => [:paypal, :dev_testing_forwarding]

	def paypal
		# p '#'*80
		# p 'request in webhooks'
		# p "#{request.inspect}"

		p '#'*80
		p 'params in webhooks'
		p "#{params.inspect}"
		
		# p '#'*80
		# p 'response in webhooks'
		# p "#{response.header.inspect}"
		# pp_id = params['resource']['parent_payment']
		# @receipt = Receipt.find_by(paypal_id: pp_id)
		respond_to do |format|
	    # format.html
	    format.json #avi: 'is my name'
	  end
	  p '#'*80
		p 'response in webhooks'
		p "#{response.header.inspect}"
		

	end

	## gonna need to deploy with this function in the cloud to enable webhooks in development... 
	## because ultra hooks is NOT https ... drrrr
	def dev_testing_forwarding
		uri = URI('http://paypal.ride4reform.ultrahook.com')
		res = Net::HTTP.post_form(uri, params )
	end

end
