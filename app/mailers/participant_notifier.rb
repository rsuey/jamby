class ParticipantNotifier < ActionMailer::Base
  default from: 'support@jamby.co'

  def group_session_booked(group_session, user)
    mail to: user.email
  end

  def booking_canceled(group_session, user)
    mail to: user.email
  end
end
