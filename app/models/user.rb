class User < ActiveRecord::Base
  has_many :bookings
  has_many :booked_sessions, through: :bookings, source: :group_session
  has_many :payment_methods

  def is_guest?
    false
  end

  def name
    email
  end
end
