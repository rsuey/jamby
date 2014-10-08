class Booking < GroupSessionsUser
  scope :upcoming, -> { joins(:group_session).where('group_sessions.ended_at IS NULL') }

  class << self
    def create(group_session, user)
      unless find_by(group_session_id: group_session.id, user_id: user.id)
        super(group_session: group_session, user: user)
        notify_create_by_email(group_session, user)
      end
    end

    def destroy(group_session, user)
      find_by(group_session_id: group_session.id, user_id: user.id).destroy
    end

    private
    def notify_create_by_email(group_session, user)
      HostNotifier.participant_joined(group_session, user).deliver
      ParticipantNotifier.group_session_booked(group_session, user).deliver
    end
  end
end
