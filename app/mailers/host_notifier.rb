class HostNotifier < ActionMailer::Base
  default from: "from@example.com"

  # en.host_notifier.participant_joined.subject
  def participant_joined(group_session, user)
    mail to: group_session.host_email
  end
end
