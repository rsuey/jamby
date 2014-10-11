class CompleteGroupSessionWorker
  include Sidekiq::Worker

  def perform(id)
    group_session = GroupSession.find(id)
    group_session.update_attributes(ended_at: Time.current)
    Sidekiq.redis { |conn| conn.del "#{self.class}:#{id}" }
  end

  def self.perform_at(run_at, id)
    jid = super
    Sidekiq.redis { |conn| conn["#{self}:#{id}"] = jid }
  end

  def self.reschedule(id, run_at)
    if GroupSession.exists?(id)
      id = Sidekiq.redis { |conn| conn["#{self}:#{id}"] }
    end
    super
  end
end
