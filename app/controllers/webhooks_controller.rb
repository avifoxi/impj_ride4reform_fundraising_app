class WebhooksController < ApplicationController
	skip_before_action :authenticate_admin!, :authenticate_user!

	protect_from_forgery :except => :paypal

	def paypal
		p '#'*80
		p 'params in webhooks'
		p "#{params.inspect}"
	end

	## gonna need to deploy with this function in the cloud to enable webhooks in development... 
	## because ultra hooks is NOT https ... drrrr
	def dev_testing_forwarding
		uri = URI('http://paypal.ride4reform.ultrahook.com')
		res = Net::HTTP.post_form(uri, params )
	end

end
