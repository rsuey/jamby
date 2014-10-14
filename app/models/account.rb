class Account < Signup
  attr_accessor :current_password

  has_many :payment_methods
  has_many :payments
  has_one :payout_account

  validate :authenticate_current_password, if: :changing_password?

  after_destroy :cancel_outstanding_bookings, :destroy_outstanding_payments

  def total_payout_due
    group_sessions.inject(0) { |sum, g| g.payout_value + sum }
  end

  def manages_payout_accounts?
    group_sessions.paid.completed.any?
  end

  private
  def cancel_outstanding_bookings
    bookings.upcoming.find_each(&:destroy)
  end

  def destroy_outstanding_payments
    payments.not_deleted.find_each do |payment|
      payment.destroy unless payment.group_session.completed?
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
