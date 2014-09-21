class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :group_session
  belongs_to :payment_method

  def save(*args)
    charge_payment_method && super
  end

  private
  def charge_payment_method
    self.currency = 'usd'
    self.amount = group_session.price_in_pennies
    charge = Charge.create(self, payment_method, user, group_session.title)
    self.remote_id = charge.id
  end
end
