class Account < Signup
  attr_accessor :current_password

  has_many :payment_methods
  has_many :payments

  validate :authenticate_current_password, if: :changing_password?

  after_destroy :destroy_outstanding_payments

  private
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
