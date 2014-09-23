require 'rails_helper'

feature 'Edit your time zone' do
  scenario 'Switch to eastern time zone us' do
    user = create(:signup)
    page = AccountDashboardPage.new

    logged_in(user) do
      page.visit
      click_link page.edit_profile_link_text
      select '(GMT-05:00) Eastern Time (US & Canada)',
             from: page.time_zone_select_label
      page.submit_form
    end

    expect(current_path).to eq(page.after_successful_profile_edit_path)
    expect(page).to have_content('Eastern Time (US & Canada)')
  end
end
