class User < ActiveRecord::Base
  has_many :group_sessions, foreign_key: :host_id

  has_many :bookings
  has_many :booked_sessions, through: :bookings, source: :group_session

  def is_guest?
    false
  end

  def name
    [first_name, last_name].join(' ')
  end
end
