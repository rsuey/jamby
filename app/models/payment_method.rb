class PaymentMethod < ActiveRecord::Base
  attr_accessor :name_on_card, :number, :cvc

  belongs_to :user

  validate :valid_card_information

  private
  def valid_card_information
    begin
      self.remote_id = customer.id
      self.last4 = customer.last_four_of_card
    rescue Customer::CardError => error
      errors.add(:base, error.message)
    end
  end

  def customer
    @customer ||= Customer.create(self, user)
  end
end
