class ParticipantNotifier < ActionMailer::Base
  default from: 'support@jamby.co'

  def group_session_booked(group_session, user)
    @group_session_title = group_session.title
    Time.use_zone(user.time_zone) do
      @start_time = group_session.starts_at.to_s
    end
    @url = group_session_url(group_session)
    mail to: user.email
  end

  def booking_canceled(group_session, user)
    @group_session_title = group_session.title
    mail to: user.email
  end

  def price_reduced(group_session, user, price_was)
    @group_session_title = group_session.title
    @price = "$#{sprintf("%.2f", group_session.price)}"
    @difference = "$#{sprintf("%.2f", price_was - group_session.price)}"
    mail to: user.email
  end

  def reminder(group_session_id, user_id)
    group_session = GroupSession.find(group_session_id)
    user = User.find(user_id)
    @group_session_title = group_session.title
    Time.use_zone(user.time_zone) do
      @start_time = group_session.starts_at.to_s
    end
    @url = group_session_url(group_session)
    mail to: user.email
  end
end
