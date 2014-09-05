require 'rails_helper'

feature 'User creates a group session' do
  scenario 'Creating a free group session' do
    page = NewGroupSessionPage.new
    page.visit
    page.fill_in_form(title: 'Free session',
                      description: 'This group session is free!',
                      price: nil)
    page.submit_form

    expect(current_path).to eq(page.after_successful_create_path)
    within(page.session_list_selector) do
      expect(page).to have_css(page.title_selector, text: 'Free session')
      expect(page).to have_css(page.description_selector,
                               text: 'This group session is free!')
      expect(page).to have_css(page.price_selector, text: 'Free')
    end
  end
end
