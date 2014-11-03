class Calendar
  def self.execute(*args)
    GoogleClient.execute(*args)
  end

  def self.events
    GoogleCalendarService.events
  end

  def self.authorization
    GoogleClient.authorization
  end
end
