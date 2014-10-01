class Booking < GroupSessionsUser
  def self.create(group_session, user)
    unless find_by(group_session_id: group_session.id, user_id: user.id)
      super(group_session: group_session, user: user)
    end
  end
end
