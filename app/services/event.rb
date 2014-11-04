require './app/services/calendar'

class Event
  attr_reader :id, :url, :summary, :description, :start_datetime, :organizer_email,
    :organizer_display_name, :end_datetime

  def initialize(group_session)
    @summary = group_session.title
    @description = group_session.description
    @start_datetime = group_session.starts_at
    @organizer_email = group_session.host_email
    @organizer_display_name = group_session.host_name
    @end_datetime = start_datetime + 1.hour
    Calendar.authorization.access_token = group_session.host_access_token
  end

  def save
    return true if defined?(@event_data)
    begin
      event = Calendar.execute(api_method: Calendar.events.insert,
                               parameters: self.class.primary_calendar_id,
                               body: to_json,
                               headers: self.class.calendar_headers)
      @event_data = event.data
      @id = @event_data.id
      @url = @event_data.hangoutLink
    rescue
      save
    end
  end

  def self.find(id)
    remote = Calendar.execute(api_method: Calendar.events.get,
                              parameters: primary_calendar_id.merge('eventId' => id))
    remote.data
  end

  def self.invite(group_session, email)
    Calendar.authorization.access_token = group_session.host_access_token

    event = find(group_session.remote_id)
    guest = { email: email, responseStatus: Rsvp::YES }
    event.attendees = event.attendees << guest # The Google API is strange, &
                                               # requires this odd assignment

    Calendar.execute(api_method: Calendar.events.update,
                     parameters: primary_calendar_id.merge('eventId' => event.id),
                     body_object: event,
                     headers: calendar_headers)
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
      guestsCanInviteOthers: false,
      anyoneCanAddSelf: true }
  end

  private
  def self.update_remote_event(event)
  end

  def self.primary_calendar_id
    { 'calendarId' => 'primary' }
  end

  def self.calendar_headers
    { 'Content-Type' => 'application/json' }
  end

  class Rsvp
    PENDING = 'needsAction'
    NO = 'declined'
    MAYBE = 'tentative'
    YES = 'accepted'
  end
end
