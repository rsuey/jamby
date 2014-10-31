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
    begin
      result = Calendar.execute(api_method: Calendar.events.insert,
                       parameters: { 'calendarId' => 'primary' },
                       body: to_json,
                       headers: { 'Content-Type' => 'application/json' })
      @id = result.data.id
      @url = result.data.hangoutLink
    rescue
      retry
    end
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
                   displayName: organizer_display_name } }
  end
end
