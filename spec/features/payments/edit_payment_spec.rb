require 'rails_helper'

feature 'User edits payment methods' do
  scenario 'User edits a payment method' do
    user = create(:account)
    page = EditPaymentMethodPage.new

    VCR.use_cassette('create a payment method') do
      create(:payment_method, account: user)
    end

    logged_in(user) do
      visit dashboard_account_path
      click_link page.edit_link_text
      page.fill_in_form('Number' => 4242424242424242,
                        'CVC' => 123)

      VCR.use_cassette('update a payment method') do
        page.submit_form
      end
    end

    expect(current_path).to eq(page.after_successful_edit_path)
    expect(page).to have_content('*4242')
  end
end
