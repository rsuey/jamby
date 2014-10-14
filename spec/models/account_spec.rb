require 'rails_helper'

describe Account do
  describe '#transfer_payouts_due!' do
    it 'transfers payouts due to its payout account' do
      account = create(:account)
      group_session = create(:group_session, host: account,
                                             price: 1, ended_at: Time.current)
      Booking.create(group_session, create(:user))

      allow(account.payout_account).to receive(:transfer)
      account.transfer_payouts_due!
      expect(account.payout_account).to have_received(:transfer).with(0.8)
    end

    it 'marks the group sessions as paid out' do
      account = create(:account)
      group_session = create(:group_session, host: account,
                                             price: 1, ended_at: Time.current)
      unended_group_session = create(:group_session, host: account, price: 1)

      Booking.create(group_session, create(:user))
      Booking.create(unended_group_session, create(:user))

      allow(account.payout_account).to receive(:transfer)
      account.transfer_payouts_due!

      expect(group_session.reload).to be_paid_out
      expect(unended_group_session.reload).not_to be_paid_out
    end
  end

  it 'knows its total payout value' do
    account = create(:account)
    group_session = create(:group_session, host: account,
                                           price: 1, ended_at: Time.current)
    group_session2 = create(:group_session, host: account,
                                            price: 1, ended_at: Time.current)
    uncompleted_group_session = create(:group_session, host: account,
                                                       price: 100)

    3.times { Booking.create(group_session, create(:user)) }
    2.times { Booking.create(group_session2, create(:user)) }
    Booking.create(uncompleted_group_session, create(:user))

    expect(account.total_payout_due).to eq(4)
  end

  it 'manages payout accounts when there are completed paid sessions' do
    user = create(:account)
    create(:group_session, price: 1, ended_at: Time.current, host: user)
    expect(user).to be_manages_payout_account
  end

  it 'does not manage payout accounts when their paid sessions are not completed' do
    user = create(:account)
    create(:group_session, price: 1, host: user)
    expect(user).not_to be_manages_payout_account
  end

  it 'does not manage payout accounts when their paid dessions were deleted' do
    user = create(:account)
    create(:group_session, price: 1, deleted_at: Time.current, host: user)
    expect(user).not_to be_manages_payout_account
  end

  it 'does not manage payout accounts when their sessions are not paid' do
    user = create(:account)
    create(:group_session, price: 0, ended_at: Time.current, host: user)
    expect(user).not_to be_manages_payout_account
  end

  it 'refunds outstanding payments on delete' do
    user = create(:account)
    upcoming_group_session = create(:group_session, price: 1)
    delete_my_payment = create(:group_session, price: 1)
    ended_group_session = create(:group_session, price: 1, ended_at: Time.current)

    user.payments.create!(group_session: upcoming_group_session)
    user.payments.create!(group_session: ended_group_session)
    payment = user.payments.create!(group_session: delete_my_payment)
    payment.destroy

    expect_any_instance_of(Payment).to receive(:destroy)
    user.destroy
  end

  it 'cancels outstanding bookings on delete' do
    user = create(:account)
    upcoming_group_session = create(:group_session, price: 1)
    ended_group_session = create(:group_session, price: 1, ended_at: Time.current)

    Booking.create(upcoming_group_session, user)
    Booking.create(ended_group_session, user)

    expect_any_instance_of(Booking).to receive(:destroy)
    user.destroy
  end
end
