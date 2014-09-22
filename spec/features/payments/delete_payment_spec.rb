require 'rails_helper'

feature 'User deletes payment method' do
  scenario 'User deletes payment method' do
    allow(Customer).to receive(:delete)

    user = create(:account)
    page = DeletePaymentMethodPage.new

    VCR.use_cassette('create a payment method') do
      create(:payment_method, account: user)
    end

    logged_in(user) do
      visit dashboard_account_path

      VCR.use_cassette('delete a payment method') do
        within('.payment_method') do
          click_link page.delete_link_text
        end
      end
    end

    expect(current_path).to eq(page.after_successful_delete_path)
    expect(page).to_not have_content('*1111')
  end
end
