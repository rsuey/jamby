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

  def time_zone
    'Pacific Time (US & Canada)'
  end
end
