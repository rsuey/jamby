class Booking < GroupSessionsUser
  scope :upcoming, -> { joins(:group_session).where('group_sessions.ended_at IS NULL') }

  class << self
    def create(group_session, user)
      unless find_by(group_session_id: group_session.id, user_id: user.id)
        super(group_session: group_session, user: user)
        notify_create_by_email(group_session, user)
        schedule_email_reminder(group_session, user)
      end
    end

    def destroy(group_session, user)
      if session = find_by(group_session_id: group_session.id, user_id: user.id)
        session.destroy
        notify_destroy_by_email(group_session, user)
      end
    end

    private
    def notify_create_by_email(group_session, user)
      HostNotifier.participant_joined(group_session).deliver
      ParticipantNotifier.group_session_booked(group_session, user).deliver
    end

    def notify_destroy_by_email(group_session, user)
      HostNotifier.participant_canceled(group_session).deliver
      ParticipantNotifier.booking_canceled(group_session, user).deliver
    end

    def schedule_email_reminder(group_session, user)
      EmailReminderWorker.perform_at(group_session.starts_at - 1.hour,
                                     group_session.id,
                                     user.id)
    end
  end
end
