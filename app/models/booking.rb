class Booking < GroupSessionsUser
  def self.create(group_session, user)
    super(group_session: group_session, user: user)
  end
end
