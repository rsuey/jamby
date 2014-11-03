class CreateEvent
  def self.create(auth, group_session)
    Calendar.authorization.access_token = auth['token']
    event = Event.new(group_session)
    event.save
    unless event.url.blank?
      group_session.update_attributes(live_url: event.url)
    end
  end
end
