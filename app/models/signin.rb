class Signin < Signup
  def save
    authenticate(password)
  end
end
