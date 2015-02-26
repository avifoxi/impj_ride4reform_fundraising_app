class PaypalPaymentPreparer
  include PayPal::SDK::REST

  attr_reader :id, :payment

  def initialize(params)
    @user = params[:user]
    @cc_info = params[:cc_info]
    @billing_address = params[:billing_address]
    @transaction_details = params[:transaction_details]
    @payment_hash = {}
    @payment = nil
    prepare_payment_hash
    # unless Rails.env.test?
    config_paypal
    # end
  end

  def prepare_payment_hash
    @payment_hash = {
      :intent => "sale",
      :payer => {
        :payment_method => "credit_card",
        :funding_instruments => [{
          :credit_card => {
            :type => @cc_info['type'],
            :number => @cc_info['number'],
            :expire_month => @cc_info['expire_month'],
            :expire_year => @cc_info['expire_year'],
            :cvv2 => @cc_info['cvv2'],
            :first_name => @user.first_name,
            :last_name => @user.last_name,
            :billing_address => {
              :line1 => @billing_address.line_1,
              :city => @billing_address.city,
              :state => @billing_address.state,
              :postal_code => @billing_address.zip,
              :country_code => "US" }}}]},
      :transactions => [{
        :item_list => {
          :items => [{
            :name => @transaction_details['name'],
            :sku => "item",
            :price => @transaction_details['amount'],
            :currency => "USD",
            :quantity => 1 
          }]},
        :amount => {
          :total => @transaction_details['amount'],
          :currency => "USD" },
        :description =>  @transaction_details['description'] }
      ]
    }

    p '$' *80
    p 'inside ppp, payment_hash post config'
    p "#{@payment_hash.inspect}"
  end

  def config_paypal
    PayPal::SDK::REST.set_config(
      :mode => "sandbox", # "sandbox" or "live"
      :client_id => ENV['PAYPAL_CLIENT_ID'],
      :client_secret =>  ENV['PAYPAL_CLIENT_SECRET'])
  end

  def create_payment
    @payment = Payment.new(@payment_hash)
    if @payment.create
      true
    else
      false
    end
  end

end