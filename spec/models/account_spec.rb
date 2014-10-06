require 'rails_helper'

describe Account do
  it 'has payout accounts' do
    user = create(:account)
    expect(user).to respond_to(:payout_accounts)
  end

  it 'manages payout accounts when there are completed paid sessions' do
    user = create(:account)
    create(:group_session, price: 1, ended_at: Time.current, host: user)
    expect(user).to be_manages_payout_accounts
  end

  it 'does not manage payout accounts when their paid sessions are not completed' do
    user = create(:account)
    create(:group_session, price: 1, host: user)
    expect(user).not_to be_manages_payout_accounts
  end

  it 'does not manage payout accounts when their paid dessions were deleted' do
    user = create(:account)
    create(:group_session, price: 1, deleted_at: Time.current, host: user)
    expect(user).not_to be_manages_payout_accounts
  end

  it 'does not manage payout accounts when their sessions are not paid' do
    user = create(:account)
    create(:group_session, price: 0, ended_at: Time.current, host: user)
    expect(user).not_to be_manages_payout_accounts
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
