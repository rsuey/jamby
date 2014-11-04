class CreateEvent
  def self.create(group_session)
    event = Event.new(group_session)
    event.save
    group_session.update_attributes(remote_id: event.id, live_url: event.url)
  end
end
