require 'rails_helper'

feature 'User cancels a group session' do
  scenario 'Cancelled sessions do not appear on the home page' do
    group_session = create(:group_session)
    page = GroupSessionPage.new(group_session)
    page.visit
    page.click_edit_link
    page.confirm_delete

    expect(current_path).to eq(page.after_successful_delete_path)
    within(page.session_list_selector) do
      expect(page).to_not have_css(page.session_selector)
    end
  end
end
