require 'rails_helper'

feature 'Edit your profile' do
  scenario 'Change your first and last name' do
    user = create(:signup)
    page = AccountDashboardPage.new

    logged_in(user) do
      page.visit
      click_link page.edit_profile_link_text
      page.fill_in_form('First name' => 'New',
                        'Last name' => 'Name')
      page.submit_form
    end

    expect(current_path).to eq(page.after_successful_profile_edit_path)
    expect(page).to have_content('New Name')
  end
end
