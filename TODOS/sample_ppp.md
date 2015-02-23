	include PayPal::SDK::REST

valid credit for sandbox:
4417119669820331
visa
11
2018
874

PayPal::SDK::REST.set_config(
	  :mode => "sandbox", 
	  :client_id => "EBWKjlELKMYqRNQ6sYvFo64FtaRLRR5BdHEESmha49TM",
	  :client_secret =>  "EO422dn3gQLgDbuwqTjzrFgFtaRLRR5BdHEESmha49TM")


"{
	:intent=>\"sale\", 
	:payer=>
		{
			:payment_method=>\"credit_card\", 
			:funding_instruments=>
			[
				{
					:credit_card=>
					{
						:type=>\"visa\", 
						:number=>\"4012888888881881\", 
						:expire_month=>\"2\", 
						:expire_year=>\"2018\", 
						:cvv2=>\"123\", 
						:first_name=>\"Avi\", 
						:last_name=>\"Rider\", 
						:billing_address=>
						{
							:line1=>\"431 East 4th st\", 
							:city=>\"Brooklyn\", 
							:state=>\"NY\", 
							:postal_code=>\"11218\", 
							:country_code=>\"US\"	
						}
					}
				}
			]
		}, 
	:transactions=>
	[
		{
			:item_list=>
			{
				:items=>
				[
					{
						:name=>\"rider registration fee\", 
						:price=>650, 
						:currency=>\"USD\", 
						:quantity=>1
					}
				]
			}, 
			:amount=>
			{
				:total=>650, 
				:currency=>\"USD\"
			}, 
			:description=>\"Registration fee for Chazzan Avi Rider, 2015\"
		}
	]
}"


PaypalPaymentPreparer.new({
	user: User.first,
	cc_info: {
		'type' => "visa",
    'number' => "4417119669820331",
    'expire_month' => "11",
    'expire_year' => "2018",
    'cvv2' => "874",
	},
	billing_address: MailingAddress.first,
	transaction_details: {
		'name' => 'foo',
		'amount' => '1.00',
		'description' => 'dexc'
	}
})












