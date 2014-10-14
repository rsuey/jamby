class ParticipantNotifier < ActionMailer::Base
  default from: 'support@jamby.co'

  def group_session_booked(group_session, user)
    @group_session_title = group_session.title
    @start_time = group_session.starts_at.strftime('%A, %b %e %l:%M%P')
    @url = group_session_url(group_session)
    mail to: user.email
  end

  def booking_canceled(group_session, user)
    @group_session_title = group_session.title
    mail to: user.email
  end

  def price_reduced(group_session, user, price_was)
    @group_session_title = group_session.title
    @price = "$#{group_session.price}"
    @difference = "$#{price_was - group_session.price}"
    mail to: user.email
  end

  def reminder(group_session_id, user_id)
    @group_session_title = group_session.title
    @start_time = group_session.starts_at.strftime('%A, %b %e %l:%M%P')
    @url = group_session_url(group_session)
    user = User.find(user_id)
    mail to: user.email
  end
end
