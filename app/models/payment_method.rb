class PaymentMethod < ActiveRecord::Base
  attr_accessor :number, :cvc

  belongs_to :user

  validate :valid_card_information

  after_destroy :delete_customer

  def display_name
    "#{brand} *#{last4} Exp. #{exp_month}/#{exp_year}"
  end

  private
  def delete_customer
    Customer.delete(remote_id)
  end

  def valid_card_information
    errors.add(:cvc, :blank) if cvc.blank?

    begin
      self.remote_id ||= customer.id
      self.last4 = customer.last_four_of_card
      self.brand = customer.card_brand
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
