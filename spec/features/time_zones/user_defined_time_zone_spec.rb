require 'rails_helper'

feature 'User degined time zones' do
  scenario 'A participant in pacific time' do
    host = create(:host, time_zone: 'Eastern Time (US & Canada)')
    time = Time.new(2014, 1, 1, 0, 0)

    Timecop.freeze(time) do
      Time.use_zone(host.time_zone) do
        create(:group_session, host: host, starts_at: Time.current)
      end
      page = GroupSessionPage.new(GroupSession.last)
      user = create(:signup, time_zone: 'Pacific Time (US & Canada)')

      logged_in(user) { page.visit }
      expect(page).to have_content('Dec 31 9:00pm')
    end
  end
end
