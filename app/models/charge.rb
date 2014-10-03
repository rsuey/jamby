class Charge
  def initialize(charge)
    @charge = charge
  end

  def id
    @charge.id
  end

  def self.create(group_session, user, payment, payment_method)
    charge = Stripe::Charge.create(
      amount: payment.amount,
      currency: payment.currency,
      customer: payment_method.remote_id,
      description: "Group session: #{group_session.hashed_id} for #{user.name}"
    )
    new(charge)
  end

  def self.refund(charge_id, options = {})
    charge = Stripe::Charge.retrieve(charge_id)
    charge.refunds.create(options)
  end
end
