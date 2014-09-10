require 'rails_helper'

feature 'User creates an account' do
  scenario 'User creates a valid, new account' do
    page = SignUpPage.new

    page.visit
    page.fill_in_form(username: 'joemsak',
                      password: 'secret83',
                      password_confirmation: 'secret83')
    page.submit_form
    page.open_in_browser

    expect(current_path).to eq(page.after_successful_signup_path)
    expect(page).to have_css('.alert-box.info',
                             text: page.successful_signup_text)
    expect(page).to have_css('.account-info .username', text: 'joemsak')
  end
end
