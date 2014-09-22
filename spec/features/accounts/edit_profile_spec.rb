require 'rails_helper'

feature 'Edit your profile' do
  scenario 'Change your first and last name' do
    user = create(:account)
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

  scenario 'Change your email address' do
    user = create(:account)
    page = AccountDashboardPage.new

    logged_in(user) do
      page.visit
      click_link page.edit_profile_link_text
      page.fill_in_form('Email' => 'newguy@example.com')
      page.submit_form
    end

    expect(current_path).to eq(page.after_successful_profile_edit_path)
    expect(page).to have_content('newguy@example.com')
  end

  scenario 'Change your password' do
    user = create(:account)
    page = AccountDashboardPage.new

    logged_in(user) do
      page.visit
      click_link page.edit_profile_link_text
      page.fill_in_form('Current password' => user.password,
                        'Password' => 'newpass123',
                        'Password confirmation' => 'newpass123')
      page.submit_form
    end

    expect(current_path).to eq(page.after_successful_profile_edit_path)
    expect(user.reload.authenticate('newpass123')).to be_truthy
  end
end
