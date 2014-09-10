class Signup < ActiveType::Record[User]
  has_secure_password
end
