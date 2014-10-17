class HostNotifier < ActionMailer::Base
  default from: "support@jamby.co"

  # en.host_notifier.participant_joined.subject
  def participant_joined(group_session)
    @group_session_title = group_session.title
    @url = group_session_url(group_session)
    mail to: group_session.host_email
  end

  def participant_canceled(group_session)
    @group_session_title = group_session.title
    mail to: group_session.host_email
  end

  def payouts_transferred(account, total_payout_amount)
    @name = account.name
    @total = total_payout_amount
    mail to: account.email
  end
end
