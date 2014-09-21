require 'rails_helper'

feature 'User adds a payment method' do
  scenario 'User adds a valid credit card' do
    user = create(:signup)
    page = AddPaymentMethodPage.new

    logged_in(user) do
      visit dashboard_account_path
      click_link page.new_payment_method_link_text
      page.fill_in_form('Name on card' => 'Joseph Sak',
                        'Number' => 4111111111111111,
                        'mm' => '08',
                        'yy' => '16',
                        'CVC' => 123)
      VCR.use_cassette('save new payment method') do
        page.submit_form
      end
    end

    expect(current_path).to eq(page.after_successful_add_path)
    expect(page).to have_content('*1111')
    expect(page).to have_content('Exp. 8/16')
    expect(user.payment_methods).to_not be_empty
  end
end
