class Signup < User
  has_secure_password

  validates :email, presence: true, uniqueness: true, email: true
  validates :first_name, :last_name, presence: true
end
