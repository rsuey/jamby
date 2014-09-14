class Guest < User
  def username
    'guest'
  end

  def is_guest?
    true
  end
end
