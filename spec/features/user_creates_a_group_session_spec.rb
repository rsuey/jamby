require 'rails_helper'

feature 'User creates a group session' do
  scenario 'Creating a free group session' do
    page = NewGroupSessionPage.new
    page.visit
    page.fill_in_form(title: 'Free session',
                      description: 'This group session is free!',
                      starts_at: '3014-01-31 5:00pm',
                      price: nil)
    page.submit_form

    expect(current_path).to eq(page.after_successful_create_path)
    within(page.session_list_selector) do
      expect(page).to have_css(page.title_selector, text: 'Free session')
      expect(page).to have_css(page.description_selector,
                               text: 'This group session is free!')
      expect(page).to have_css(page.date_selector, text: 'Monday, Jan 31')
      expect(page).to have_css(page.time_selector, text: '5:00pm')
      expect(page).to have_css(page.price_selector, text: 'Free')
    end
  end
end
