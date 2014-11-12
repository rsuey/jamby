class Account < Signup
  attr_accessor :current_password

  has_many :payment_methods
  has_many :payments
  has_one :payout_account

  validate :authenticate_current_password, if: :changing_password?

  after_destroy :cancel_outstanding_bookings, :destroy_outstanding_payments

  def transfer_payouts_due!
    if payable? && payout_account.present?
      payout_account.transfer(total_payout_due)
      group_sessions.completed.unpaid_out.find_each(&:payout!)
      HostNotifier.payouts_transferred(self, total_payout_due).deliver
    end
  end

  def total_payout_due
    group_sessions.completed.inject(0) { |sum, g| g.payout_value + sum }
  end

  def payable?
    total_payout_due > 0
  end

  private
  def cancel_outstanding_bookings
    bookings.upcoming.find_each(&:destroy)
  end

  def destroy_outstanding_payments
    payments.not_deleted.find_each do |payment|
      if payment.group_session && !payment.group_session.completed?
        payment.destroy
      end
    end
  end

  def authenticate_current_password
    unless authenticate(current_password)
      errors.add(:current_password, :incorrect)
    end
  end

  def changing_password?
    !password_reset_token.blank? && !password.blank? && !authenticate(password)
  end
end
