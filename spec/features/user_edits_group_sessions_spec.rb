require 'rails_helper'

feature 'User edits group sessions' do
  scenario 'Editing a group session' do
    group_session = create(:group_session, title: 'Free session')
    page = GroupSessionPage.new(group_session)
    page.visit
    page.click_edit_link
    page.fill_in_form(title: 'Paid session', price: 1)
    page.submit_form

    expect(current_path).to eq(page.after_successful_edit_path)
    within(page.session_selector) do
      expect(page).to have_css(page.title_selector, text: 'Paid session')
      expect(page).to have_css(page.price_selector, text: '$1.00')
    end
  end
end
