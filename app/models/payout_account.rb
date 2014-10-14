class PayoutAccount < ActiveRecord::Base
  attr_accessor :country, :routing_number, :account_number

  belongs_to :account

  validates :name, :country, :routing_number, :account_number, presence: true

  after_initialize :default_account_type_to_individual
  before_save :create_recipient

  def display_name
    [bank_name, last4].join(' xxxxx')
  end

  def transfer(amount)
    Recipient.transfer(remote_id, amount * 100)
  end

  private
  def default_account_type_to_individual
    self.account_type ||= 'individual'
  end

  def create_recipient
    self.remote_id = recipient.id
    self.last4 = recipient.last4
    self.bank_name = recipient.bank_name
  end

  def recipient
    @recipient ||= Recipient.create(name: name, type: account_type,
                                    bank_account: {
                                      country: country,
                                      routing_number: routing_number,
                                      account_number: account_number
                                    })
  end
end
