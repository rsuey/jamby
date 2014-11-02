require './app/services/calendar'

class Event
  attr_reader :id, :summary, :description, :start_datetime, :organizer_email,
    :organizer_display_name, :end_datetime, :url

  def initialize(group_session)
    @summary = group_session.title
    @description = group_session.description
    @start_datetime = group_session.starts_at
    @organizer_email = group_session.host_email
    @organizer_display_name = group_session.host_name
    @end_datetime = start_datetime + 1.hour
  end

  def save
    remote_event = create_remote_event
    @id = remote_event.id
    @url = remote_event.hangoutLink
    true
  end

  def self.find(id)
    remote = Calendar.execute(api_method: Calendar.events.get,
                              parameters: primary_calendar_id.merge('eventId' => id))
    remote.data
  end

  def self.update(id, attrs = {})
    event = find(id)
    attrs.each { |k, v| event.send("#{k}=", v) }
    update_remote_event(id, event)
  end

  def to_json
    JSON.dump(to_hash)
  end

  def to_hash
    { summary: summary,
      description: description,
      start: { dateTime: start_datetime.to_datetime.rfc3339 },
      end: { dateTime: end_datetime.to_datetime.rfc3339 },
      organizer: { email: organizer_email,
                   displayName: organizer_display_name },
      anyoneCanAddSelf: true }
  end

  private
  def create_remote_event
    begin
      event = Calendar.execute(api_method: Calendar.events.insert,
                               parameters: self.class.primary_calendar_id,
                               body: to_json,
                               headers: self.class.calendar_headers)
      event.data
    rescue
      retry
    end
  end

  def self.update_remote_event(id, event)
    Calendar.execute(api_method: Calendar.events.update,
                     parameters: primary_calendar_id.merge('eventId' => id),
                     body_object: event,
                     headers: calendar_headers)
  end

  def self.primary_calendar_id
    { 'calendarId' => 'primary' }
  end

  def self.calendar_headers
    { 'Content-Type' => 'application/json' }
  end
end
