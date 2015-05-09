class WebhooksController < ApplicationController
	skip_before_action :authenticate_admin!, :authenticate_user!

	protect_from_forgery :except => [:paypal, :dev_testing_forwarding]

	def paypal
		p '#'*80
		p 'params in webhooks'
		p "#{params.inspect}"

		pp_id = params['resource']['parent_payment']
		@receipt = Receipt.find_by(paypal_id: pp_id)	
	end

	## gonna need to deploy with this function in the cloud to enable webhooks in development... 
	## because ultra hooks is NOT https ... drrrr
	def dev_testing_forwarding
		uri = URI('http://paypal.ride4reform.ultrahook.com')
		res = Net::HTTP.post_form(uri, params )
	end

end
