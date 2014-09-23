class Signin < Signup
  def save
    persisted? && authenticate(password) && super
  end
end
