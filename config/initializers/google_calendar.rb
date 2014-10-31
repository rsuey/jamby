require 'rubygems'
require 'google/api_client'
require 'yaml'

oauth_yaml = YAML.load_file('.google-api.yaml')
GoogleClient = Google::APIClient.new

GoogleClient.authorization.client_id = oauth_yaml["client_id"]
GoogleClient.authorization.client_secret = oauth_yaml["client_secret"]
GoogleClient.authorization.scope = oauth_yaml["scope"]
GoogleClient.authorization.refresh_token = oauth_yaml["refresh_token"]
GoogleClient.authorization.access_token = oauth_yaml["access_token"]

if GoogleClient.authorization.refresh_token && GoogleClient.authorization.expired?
  GoogleClient.authorization.fetch_access_token!
end

GoogleCalendarService = GoogleClient.discovered_api('calendar', 'v3')
