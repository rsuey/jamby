class CreateEvent
  def self.create(group_session)
    event = Event.new(group_session)
    event.save
    group_session.update_attributes(live_url: event.url)
  end
end
