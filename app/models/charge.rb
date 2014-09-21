class Charge
  def initialize(charge)
    @charge = charge
  end

  def id
    @charge.id
  end

  def self.create(payment, payment_method, user, title)
    charge = Stripe::Charge.create(amount: payment.amount,
                                   currency: payment.currency,
                                   customer: payment_method.remote_id,
                                   description: "Charge for #{user.email} booking #{title}")
    new(charge)
  end
end
