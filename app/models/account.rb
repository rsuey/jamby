class Account < Signup
  attr_accessor :current_password

  has_many :payment_methods
  has_many :payments

  validate :authenticate_current_password, if: :changing_password?

  after_destroy :cancel_outstanding_bookings, :destroy_outstanding_payments

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
    !password.blank? && !authenticate(password)
  end
end
