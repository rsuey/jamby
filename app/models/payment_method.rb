class PaymentMethod < ActiveRecord::Base
  belongs_to :user

  attr_accessor :name_on_card, :number, :cvc

  def save
    save_customer && super
  end

  private
  def save_customer
    customer = Stripe::Customer.create(
      card: {
        name: name_on_card,
        number: number,
        cvc: cvc,
        exp_month: exp_month,
        exp_year: exp_year
      },
      description: user.email
    )
    self.remote_id = customer.id
    self.last4 = customer.cards.data[0].last4
  end
end
