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

  scenario 'Creating an invalid group session' do
    page = NewGroupSessionPage.new
    page.visit
    page.fill_in_form(title: nil,
                      description: nil,
                      starts_at: nil)
    page.submit_form

    expect(current_path).to eq(page.after_failed_create_path)
    within(page.error_field_css) do
      expect(page).to have_content(page.blank_title_error)
      expect(page).to have_content(page.blank_description_error)
      expect(page).to have_content(page.blank_starts_at_error)
    end
  end
end
