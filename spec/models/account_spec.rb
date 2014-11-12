require 'rails_helper'

describe Account do
  describe '#transfer_payouts_due!' do
    it 'transfers payouts due to its payout account' do
      account = create(:account)
      payout_account = double(:payout_account)
      group_session = create(:completed_group_session, host: account)

      group_session.payments.create!(amount: 100)

      allow(account).to receive(:payout_account) { payout_account }
      allow(payout_account).to receive(:transfer)

      account.transfer_payouts_due!

      expect(account.payout_account).to have_received(:transfer).with(0.8)
    end

    it 'marks the group sessions as paid out' do
      account = create(:account)
      group_session = create(:completed_group_session, host: account)
      uncompleted_group_session = create(:priced_group_session, host: account)

      group_session.payments.create!(amount: 100)
      uncompleted_group_session.payments.create!(amount: 100)

      VCR.use_cassette('create payout account') do
        create(:payout_account, account: account)
      end

      VCR.use_cassette('tranfer payouts due') do
        account.transfer_payouts_due!
      end

      expect(group_session.reload).to be_paid_out
      expect(uncompleted_group_session.reload).not_to be_paid_out
    end

    it 'sends the host an email' do
      ActionMailer::Base.deliveries.clear

      account = create(:account)
      group_session = create(:completed_group_session, host: account)
      group_session.payments.create!(amount: 100)

      VCR.use_cassette('create payout account') do
        create(:payout_account, account: account)
      end

      VCR.use_cassette('tranfer payouts due') do
        account.transfer_payouts_due!
      end

      email = ActionMailer::Base.deliveries.last

      expect(email.to).to eq([account.email])
      expect(email.subject).to eq("You've been paid!")
      expect(email.text_part.decoded).to include('$0.80')
    end
  end

  it 'knows its total payout value' do
    account = create(:account)
    group_session = create(:completed_group_session, host: account)
    group_session2 = create(:completed_group_session, host: account)
    uncompleted_group_session = create(:group_session, host: account)

    3.times { group_session.payments.create!(amount: 100) }
    2.times { group_session2.payments.create!(amount: 100) }
    uncompleted_group_session.payments.create!(amount: 50_000)

    expect(account.total_payout_due).to eq(4)
  end

  it 'is payable when there are completed paid sessions' do
    account = create(:account)
    session = create(:completed_group_session, price: 1, host: account)
    session.payments.create!(amount: 1)
    expect(account).to be_payable
  end

  it 'is not payable when their paid sessions are not completed' do
    account = create(:account)
    session = create(:priced_group_session, host: account)
    session.payments.create!(amount: 1)
    expect(account).not_to be_payable
  end

  it 'is not payable when their paid dessions were deleted' do
    account = create(:account)
    session = create(:deleted_group_session, price: 1, host: account)
    session.payments.create!(amount: 1)
    expect(account).not_to be_payable
  end

  it 'is not payable when their sessions are not paid' do
    account = create(:account)
    create(:completed_group_session, host: account)
    expect(account).not_to be_payable
  end

  it 'refunds outstanding payments on delete' do
    account = create(:account)

    upcoming_group_session = create(:priced_group_session)
    completed_group_session = create(:completed_group_session, price: 1)

    preserved_payment = create(:payment, group_session: completed_group_session,
                                         account: account)
    deleted_payment = create(:payment, group_session: upcoming_group_session,
                                       account: account)
    orphaned_payment = create(:payment, account: account)

    account.destroy

    expect(completed_group_session.reload.payments).to eq([preserved_payment])
    expect(upcoming_group_session.reload.payments).to eq([])
    expect(deleted_payment.reload).to be_deleted
  end

  it 'cancels outstanding bookings on delete' do
    account = create(:account)
    upcoming_group_session = create(:priced_group_session)
    completed_group_session = create(:completed_group_session, price: 1)

    Booking.create(upcoming_group_session, account)
    Booking.create(completed_group_session, account)

    account.destroy

    expect(Booking.find(upcoming_group_session, account)).to be_nil
    expect(Booking.find(completed_group_session, account)).not_to be_nil
  end
end
