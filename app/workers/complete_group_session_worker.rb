class CompleteGroupSessionWorker
  include Sidekiq::Worker

  def perform(id)
    GroupSession.find(id).complete!
  end

  def self.reschedule(jid)
    Sidekiq::ScheduledSet.new.find_job(jid).reschedule(Time.current + 15.minutes)
  end
end
