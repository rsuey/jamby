class CompleteGroupSessionWorker
  include Sidekiq::Worker

  def perform(id)
    group_session = GroupSession.find(id)
    group_session.update_attributes(ended_at: Time.current)
  end

  def self.reschedule(jid)
    Sidekiq::ScheduledSet.new.find_job(jid).reschedule(Time.current + 15.minutes)
  end
end
