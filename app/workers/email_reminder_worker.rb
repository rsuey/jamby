class EmailReminderWorker
  include Sidekiq::Worker

  def perform(group_session_id, user_id)
    ParticipantNotifier.reminder(group_session_id, user_id).deliver
  end
end
