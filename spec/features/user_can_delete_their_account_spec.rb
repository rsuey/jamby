require 'rails_helper'

feature 'Users can delete their accounts' do
  scenario 'User deletes their account' do
    page = AccountDashboardPage.new
    user = create(:signin)

    logged_in(user) do
      visit root_path
      click_link user.username
      click_link page.delete_account_link_text

      expect(current_path).to eq(page.after_successful_delete_path)
      expect(page).to have_css('.alert-box.info',
                               text: page.successful_delete_text)
      expect(page).to have_css('.account-info .username', text: 'guest')
    end

    page = SignInPage.new
    page.visit

    page.fill_in_form(username: user.username, password: user.password)
    page.submit_form

    expect(current_path).to eq(page.after_failed_signin_path)
    expect(page).to have_css('.alert-box.alert',
                             text: page.invalid_credentials_text)
  end
end
