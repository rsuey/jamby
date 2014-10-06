class PayoutAccount < ActiveRecord::Base
  attr_accessor :country, :routing_number, :account_number

  validates :name, :country, :routing_number, :account_number, presence: true

  after_initialize :default_account_type_to_individual
  before_save :create_recipient

  def display_name
    [bank_name, last4].join(' xxxxx')
  end

  private
  def default_account_type_to_individual
    self.account_type ||= 'individual'
  end

  def create_recipient
    recipient = Stripe::Recipient.create(name: name,
                                         type: account_type,
                                         bank_account: {
                                           country: country,
                                           routing_number: routing_number,
                                           account_number: account_number
                                         })
    self.remote_id = recipient.id
    self.last4 = recipient.active_account.last4
    self.bank_name = recipient.active_account.bank_name
  end
end
