class User < ActiveRecord::Base
  has_many :bookings
  has_many :booked_sessions, through: :bookings, source: :group_session

  def is_guest?
    false
  end

  def name
    email
  end
end
