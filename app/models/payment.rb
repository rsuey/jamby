class Payment < ActiveRecord::Base
  belongs_to :account
  belongs_to :group_session
  belongs_to :payment_method

  after_destroy :refund_charge

  def save(*args)
    charge_payment_method && super
  end

  private
  def charge_payment_method
    return true if deleted?
    self.currency = 'usd'
    self.amount = group_session.price_in_pennies
    charge = Charge.create(self, payment_method, account, group_session.title)
    self.remote_id = charge.id
  end

  def refund_charge
    return true if remote_id.blank?
    refund = Charge.refund(remote_id)
    self.remote_refund_id = refund.id
    save
  end
end
