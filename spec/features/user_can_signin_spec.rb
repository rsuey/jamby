require 'rails_helper'

feature 'Users can sign in' do
  scenario 'User enters valid credentials' do
    create(:signup, username: 'coolguy', password: 'secret83')
    page = SignInPage.new
    visit root_path
    click_link page.signin_link_text

    page.fill_in_form(username: 'coolguy', password: 'secret83')
    page.submit_form

    expect(current_path).to eq(page.after_successful_signin_path)
    expect(page).to have_css('.alert-box.info',
                             text: page.successful_signin_text)
    expect(page).to have_css('.account-info .username', text: 'coolguy')
  end

  scenario 'User logs out' do
    page = SignInPage.new

    logged_in do
      visit root_path
      click_link page.signout_link_text

      expect(current_path).to eq(page.after_successful_signout_path)
      expect(page).to have_css('.alert-box.info',
                               text: page.successful_signout_text)
      expect(page).to have_css('.account-info .username', text: 'guest')
    end
  end
end
