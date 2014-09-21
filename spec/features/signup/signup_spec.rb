require 'rails_helper'

feature 'User creates an account' do
  scenario 'User creates a valid, new account' do
    page = SignUpPage.new

    visit root_path
    click_link page.signup_link_text

    page.fill_in_form('Email' => 'joe@sak.com',
                      'First name' => 'Joe',
                      'Last name' => 'Sak',
                      'Password' => 'secret83',
                      'Password confirmation' => 'secret83')
    page.submit_form

    expect(current_path).to eq(page.after_successful_signup_path)
    expect(page).to have_css('.alert-box.info',
                             text: page.successful_signup_text)
    expect(page).to have_link('Joe')
  end
end
