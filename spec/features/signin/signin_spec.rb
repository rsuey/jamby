require 'rails_helper'

feature 'Users can sign in' do
  scenario 'User enters valid credentials' do
    create(:signup, first_name: 'Cool',
                    email: 'coolguy@email.com',
                    password: 'secret83')
    page = SignInPage.new
    visit root_path
    click_link page.signin_link_text

    page.fill_in_form('Email' => 'coolguy@email.com',
                      'Password' => 'secret83')
    page.submit_form

    expect(current_path).to eq(page.after_successful_signin_path)
    expect(page).to have_css('.alert-box.info',
                             text: page.successful_signin_text)
    expect(page).to have_link('Cool')
  end

  scenario 'User wants to be remembered' do
    create(:signup, first_name: 'Cool',
                    email: 'coolguy@email.com',
                    password: 'secret83')
    page = SignInPage.new
    visit root_path
    click_link page.signin_link_text

    page.fill_in_form('Email' => 'coolguy@email.com',
                      'Password' => 'secret83')
    check page.remember_me_text
    page.submit_form

    expire_cookies
    cookie = get_me_the_cookie('auth_token')
    expect(cookie).to_not be_nil
    expect(current_path).to eq(page.after_successful_signin_path)
    expect(page).to have_css('.alert-box.info',
                             text: page.successful_signin_text)
    expect(page).to have_link('Cool')
  end

  scenario 'User logs out' do
    page = SignInPage.new

    logged_in do
      visit root_path
      click_link page.signout_link_text
    end

    expect(current_path).to eq(page.after_successful_signout_path)
    expect(page).to have_css('.alert-box.info',
                             text: page.successful_signout_text)
    expect(page).to have_link('Guest')
  end
end
