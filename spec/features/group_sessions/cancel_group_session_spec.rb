require 'rails_helper'

feature 'User cancels a group session' do
  scenario 'Cancelled sessions do not appear on the home page' do
    user = create(:signup)
    group_session = create(:group_session, host: user)
    page = GroupSessionPage.new(group_session)

    logged_in(user) do
      page.visit
      page.click_edit_link
      page.confirm_delete
    end

    expect(current_path).to eq(page.after_successful_delete_path)
    within(page.session_list_selector) do
      expect(page).to_not have_css(page.session_selector)
    end
  end
end
