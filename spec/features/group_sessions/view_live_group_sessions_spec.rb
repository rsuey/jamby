require 'rails_helper'

feature 'Users can view live group sessions' do
  scenario 'User sees group sessions that are currently live' do
    page = GroupSessionsPage.new
    time = DateTime.new(2014, 01, 31, 17, 30)
    create(:group_session, title: 'Live now', starts_at: time - 30.minutes)
    create(:group_session, title: 'Not live now', starts_at: time + 30.minutes)

    Timecop.freeze(time) do
      page.visit

      within('#live_sessions') do
        expect(page).to have_css('h1', text: page.live_sessions_title)
        expect(page).to have_content('Live now')
        expect(page).to_not have_content('Not live now')
      end
    end
  end

  scenario 'User sees group sessions that they have booked' do
    page = GroupSessionsPage.new
    user = create(:signup)
    booked = create(:group_session, title: 'Booked session')
    create(:group_session, title: 'Not booked')

    Booking.create(booked, user)

    logged_in(user) { page.visit }

    click_link 'My Sessions'

    within('#booked_sessions') do
      expect(page).to have_css('h1', text: page.booked_sessions_title)
      expect(page).to have_content('Booked session')
      expect(page).to_not have_content('Not booked')
    end
  end

  scenario 'User sees upcoming group sessions' do
    page = GroupSessionsPage.new
    time = DateTime.new(2014, 01, 31, 17, 30)
    create(:group_session, title: 'Live now', starts_at: time - 30.minutes)
    create(:group_session, title: 'Upcoming session', starts_at: time + 30.minutes)

    Timecop.freeze(time) do
      page.visit

      within('#upcoming_sessions') do
        expect(page).to have_css('.label', text: page.upcoming_sessions_title)
        expect(page).to have_content('Upcoming session')
        expect(page).to_not have_content('Live now')
      end
    end
  end
end
