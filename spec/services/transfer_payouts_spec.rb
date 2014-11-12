require 'rails_helper'

describe TransferPayouts do
  it 'transfers payments to accounts and notifies them' do
    account = create(:account)

    group_session = create(:completed_group_session, price: 1, host: account)
    uncompleted_group_session = create(:priced_group_session, host: account)

    group_session.payments.create!(amount: 100)
    uncompleted_group_session.payments.create!(amount: 100)

    VCR.use_cassette('create payout account') do
      create(:payout_account, account: account)
    end

    VCR.use_cassette('tranfer payouts due') do
      TransferPayouts.transfer(account)
    end

    email = ActionMailer::Base.deliveries.last

    expect(email.to).to eq([account.email])
    expect(email.subject).to eq("You've been paid!")
    expect(email.text_part.decoded).to include('$0.80')

    expect(GroupSession.completed.first).to be_paid_out
    expect(GroupSession.not_completed.first).not_to be_paid_out

    expect(account.total_payout_due).to be_zero
  end
end
