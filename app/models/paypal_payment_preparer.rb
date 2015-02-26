# require 'paypal-sdk-rest'
# PayPal::SDK::Core::Config.load('spec/config/paypal.yml',  ENV['RACK_ENV'] || 'development')

# PayPal::SDK::REST.set_config(
#     :mode => "sandbox", # "sandbox" or "live"
#     :client_id => ENV['PAYPAL_CLIENT_ID'],
#     :client_secret =>  ENV['PAYPAL_CLIENT_SECRET'])

class PaypalPaymentPreparer
  include PayPal::SDK::REST

  attr_reader :payment_hash, :id, :payment

  def initialize(params)
    @user = params[:user]
    @cc_info = params[:cc_info]
    @billing_address = params[:billing_address]
    @transaction_details = params[:transaction_details]
    @payment_hash = {}
    @payment = nil
    prepare_payment_hash
    config_paypal
    # create_payment
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

# '%.2f' %


# PaypalPaymentPreparer.new({user: User.first, billing_address: MailingAddress.first, cc_info: cc_info, transaction_details: transaction_details })

# transaction_details = {'name' => 'rider registration fee', 'amount' => 650, 'description' => 'rider registration fee'}


# cc_info = {'type' => 'visa', 'number'=> '123', 'expire_month' => '123', 'expire_year' => '2016'}


# # Build Payment object
# @payment = Payment.new({
#   :intent => "sale",
#   :payer => {
#     :payment_method => "credit_card",
#     :funding_instruments => [{
#       :credit_card => {
#         :type => "visa",
#         :number => "4417119669820331",
#         :expire_month => "11",
#         :expire_year => "2018",
#         :cvv2 => "874",
#         :first_name => "Joe",
#         :last_name => "Shopper",
#         :billing_address => {
#           :line1 => "52 N Main ST",
#           :city => "Johnstown",
#           :state => "OH",
#           :postal_code => "43210",
#           :country_code => "US" }}}]},
#   :transactions => [{
#     :item_list => {
#       :items => [{
#         :name => "item",
#         :sku => "item",
#         :price => "1",
#         :currency => "USD",
#         :quantity => 1 }]},
#     :amount => {
#       :total => "1.00",
#       :currency => "USD" },
#     :description => "This is the payment transaction description." }]})

# Create Payment and return the status(true or false)
# if @payment.create
#   @payment.id     # Payment Id
# else
#   @payment.error  # Error Hash
# end