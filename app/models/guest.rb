class Guest < User
  def first_name
    'Guest'
  end

  def is_guest?
    true
  end
end
