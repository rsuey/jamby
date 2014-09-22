class Guest < User
  def first_name
    'Guest'
  end

  def payment_methods
    []
  end

  def is_guest?
    true
  end
end
