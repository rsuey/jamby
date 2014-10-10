class ParticipantNotifier < ActionMailer::Base
  default from: 'support@jamby.co'

  def group_session_booked(group_session, user)
    mail to: user.email
  end

  def booking_canceled(group_session, user)
    mail to: user.email
  end

  def price_reduced(group_session, user)
    mail to: user.email
  end

  def reminder(group_session_id, user_id)
    user = User.find(user_id)
    mail to: user.email
  end
end
