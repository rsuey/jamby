class Signin < Signup
  def save
    persisted? && authenticate(password)
  end
end
