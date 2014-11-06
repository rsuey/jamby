require 'rubygems'
require 'google/api_client'

procedure = lambda {
  GoogleClient = Google::APIClient.new

  GoogleClient.authorization.client_id = ENV['GOOGLE_CLIENT_ID']
  GoogleClient.authorization.client_secret = ENV['GOOGLE_CLIENT_SECRET']
  GoogleClient.authorization.scope = 'https://www.googleapis.com/auth/calendar'

  if GoogleClient.authorization.refresh_token && GoogleClient.authorization.expired?
    GoogleClient.authorization.fetch_access_token!
  end

  GoogleCalendarService = GoogleClient.discovered_api('calendar', 'v3')
}

if defined?(VCR)
  require 'vcr_helper'
  VCR.use_cassette('google client', &procedure)
else
  procedure.call
end
