require 'rails_helper'

feature 'Reaching the booking limit' do
  scenario 'User cannot book fully booked session' do
    user = create(:signup)
    group_session = create(:group_session)

    10.times { Booking.create(group_session, create(:user)) }

    logged_in(user) { visit group_session_path(group_session) }

    expect(page).to have_css('.button.disabled', text: I18n.t('text.models.group_session.fully_booked'))
  end
end
