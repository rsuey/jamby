class Account < Signup
  attr_accessor :current_password

  has_many :payment_methods

  validate :authenticate_current_password, if: :changing_password?

  private
  def authenticate_current_password
    unless authenticate(current_password)
      errors.add(:current_password, :incorrect)
    end
  end

  def changing_password?
    !password.blank? && !authenticate(password)
  end
end
