require 'active_support/all'
require 'google/api_client'
require './config/initializers/google_calendar'
require './app/services/event'

describe Event do
  it 'builds from a group session' do
    time = Time.new(2014, 10, 31, 11, 46, 53)
    group_session = double(:group_session, title: 'Title',
                                           description: 'Hello world',
                                           starts_at: time,
                                           host_name: 'Joe Sak',
                                           host_email: 'joe@joesak.com')

    event = Event.new(group_session)

    expect(event.summary).to eq('Title')
    expect(event.description).to eq('Hello world')
    expect(event.start_datetime).to eq(time)
    expect(event.organizer_email).to eq('joe@joesak.com')
    expect(event.organizer_display_name).to eq('Joe Sak')
  end

  it 'creates on the calendar' do
    group_session = double(:group_session, title: 'Title',
                                           description: 'Hello world',
                                           starts_at: Time.current,
                                           host_name: 'Joe Sak',
                                           host_email: 'joe@joesak.com')

    event = Event.new(group_session)
    event.save

    expect(event.id).not_to be_nil
    expect(event.url).not_to be_nil
  end
end
