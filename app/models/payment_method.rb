class PaymentMethod < ActiveRecord::Base
  attr_accessor :name_on_card, :number, :cvc

  belongs_to :user

  validate :valid_card_information

  private
  def valid_card_information
    errors.add(:cvc, :blank) if cvc.blank?

    begin
      self.remote_id ||= customer.id
      self.last4 = customer.last_four_of_card
    rescue Customer::CardError => error
      errors.add(:base, error.message)
    end
  end

  def customer
    if persisted?
      @customer ||= Customer.update(self)
    else
      @customer ||= Customer.create(self, user)
    end
  end
end
