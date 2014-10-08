class Booking < GroupSessionsUser
  scope :upcoming, -> { joins(:group_session).where('group_sessions.ended_at IS NULL') }

  def self.create(group_session, user)
    unless find_by(group_session_id: group_session.id, user_id: user.id)
      super(group_session: group_session, user: user)
      HostNotifier.participant_joined(group_session, user).deliver
    end
  end

  def self.destroy(group_session, user)
    find_by(group_session_id: group_session.id, user_id: user.id).destroy
  end
end
