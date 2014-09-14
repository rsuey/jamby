class Guest < User
  def username
    'Guest'
  end

  def is_guest?
    true
  end
end
