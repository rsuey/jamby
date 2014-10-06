require 'rails_helper'

feature 'Creating a payouts account' do
  scenario 'A user who has not completed paid group sessions gets no link' do
    user = create(:signup)
    create(:group_session, price: 0, host: user)
    create(:group_session, price: 1, host: user)
    create(:group_session, price: 1, deleted_at: Time.current, host: user)
    create(:group_session, price: 0, ended_at: nil, host: user)

    logged_in(user) { visit dashboard_account_path }

    expect(page).not_to have_link(I18n.t('links.models.payout_account.new'))
  end

  scenario 'Create the payouts account' do
    user = create(:signup)
    create(:group_session, price: 1, ended_at: Time.current, host: user)

    logged_in(user) do
      visit dashboard_account_path
      click_link I18n.t('links.models.payout_account.new')

      fill_in 'Your name', with: 'Joe Sak'
      fill_in 'Country', with: 'US'
      fill_in 'Routing number', with: '110000000'
      fill_in 'Account number', with: '000123456789'

      VCR.use_cassette('save payout account') do
        click_button I18n.t('forms.models.payout_account.create')
      end
    end

    expect(current_path).to eq(dashboard_account_path)
    within('.payout_account') do
      expect(page).to have_content('STRIPE TEST BANK xxxxx6789')
    end
  end
end
