class Account < Signup
  has_many :payment_methods
end
