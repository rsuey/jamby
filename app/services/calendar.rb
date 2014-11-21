class Calendar
  @test_mode = false

  class << self
    attr_reader :test_mode

    def execute(*args)
      replace_in_test_mode_with(fake_data) { GoogleClient.execute(*args) }
    end

    def events
      replace_in_test_mode_with(FakeEvents.new) { GoogleCalendarService.events }
    end

    def authorization
      replace_in_test_mode_with(FakeAuth.new) { GoogleClient.authorization }
    end

    def test_mode!
      @test_mode = true
    end

    def create_group_session_path
      if Calendar.test_mode
        '/events'
      else
        '/auth/google_oauth2' # must create event in host's calendar
        # check SignupsController#update
      end
    end

    private
    def replace_in_test_mode_with(fake_object, &block)
      if test_mode
        fake_object
      else
        yield
      end
    end

    def fake_data
      data = OpenStruct.new(id: 'googlecalendarid', hangoutLink: 'hangoutLink')
      FakeData.new(data: data)
    end

    FakeAuth, FakeData, FakeEvents = OpenStruct, OpenStruct, OpenStruct
  end
end
