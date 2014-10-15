require 'rails_helper'

describe GroupSession do
  it 'tracks payout and total value if the price changes' do
    group_session = create(:completed_group_session)

    group_session.payments.create!(amount: 100)
    group_session.payments.create!(amount: 50)

    expect(group_session.total_value).to eq(1.5)
    expect(group_session.payout_value).to eq(1.2)
  end

  it 'has a payout value of 0 when it is not completed' do
    group_session = create(:group_session)
    group_session.payments.create!(amount: 100)
    expect(group_session.payout_value).to eq(0)
  end

  it 'has a payout value of 0 when it has been paid' do
    group_session = create(:group_session)

    group_session.payments.create!(amount: 100)
    group_session.update_attributes(paid_out_at: Time.current)

    expect(group_session).to be_paid_out
    expect(group_session.payout_value).to eq(0)
  end

  it 'delegates name, avatar, and email to the host' do
    user = create(:user, first_name: 'Foo', last_name: 'Bar',
                         email: 'host@example.com')
    group_session = build(:group_session, host: user)
    expect(group_session.host_email).to eq('host@example.com')
    expect(group_session.host_name).to eq('Foo Bar')
    expect(group_session.host_avatar).not_to be_nil
  end

  it 'uses a hashed ID' do
    group_session = create(:group_session)
    expect(group_session.hashed_id).not_to be_nil
    expect(GroupSession.find(group_session.hashed_id)).not_to be_nil
  end

  it 'is not fully booked before 10 bookings' do
    group_session = create(:group_session)
    expect(group_session).not_to be_fully_booked

    9.times { Booking.create(group_session, create(:user)) }
    expect(group_session.reload).not_to be_fully_booked

    Booking.create(group_session, create(:user))
    expect(group_session.reload).to be_fully_booked
  end

  it 'refunds users the difference when the price is lowered' do
    VCR.use_cassette('refund difference on lowered price') do
      group_session = create(:group_session, price: 2)
      payment_method = create(:payment_method)
      account = create(:account)
      payment = group_session.payments.create(amount: 200,
                                              account: account,
                                              payment_method: payment_method)

      Booking.create(group_session, account)
      group_session.update_attributes(price: 1)

      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq([account.email])
      expect(email.subject).to eq('Price reduced')
      expect(payment.reload.remote_refund_id).not_to be_nil
    end
  end

  it 'returns the youtube embed path' do
    group_session = build(:group_session, broadcast_id: 'fooBar')
    expect(group_session.broadcast_embed).to eq('//youtube.com/embed/fooBar')
  end

  it 'is #live_details_ready? if live_url and broadcast_id are present' do
    group_session = build(:group_session)
    expect(group_session).to_not be_live_details_ready

    group_session = build(:group_session, live_url: 'present',
                                          broadcast_id: 'here')
    expect(group_session).to be_live_details_ready
  end

  it 'is paid when it is free' do
    group_session = build(:free_group_session)
    expect(group_session).to be_paid(double(:account))
  end

  it 'is not paid when it is priced and no payments' do
    group_session = build(:priced_group_session)
    expect(group_session).to_not be_paid(double(:account))
  end

  it 'is paid by users who have paid for it' do
    account = create(:account)
    group_session = create(:priced_group_session)
    create(:payment, group_session: group_session, account: account)
    expect(group_session).to be_paid(account)
  end

  it 'is not paid if the user payment is deleted' do
    account = create(:account)
    group_session = create(:priced_group_session)
    create(:deleted_payment, group_session: group_session, account: account)
    expect(group_session).to_not be_paid(account)
  end

  it 'can generally be booked' do
    user = double(:user)
    group_session = build(:group_session)
    expect(group_session).to be_bookable_by(user)
  end

  it 'cannot be booked by the host' do
    user = create(:user)
    group_session = build(:group_session, host: user)
    expect(group_session).not_to be_bookable_by(user)
  end

  it 'cannot be double booked' do
    user = create(:user)
    group_session = create(:group_session)

    Booking.create(group_session, user)
    expect(group_session).not_to be_bookable_by(user)
  end

  it 'is not booked out of thin air' do
    group_session = build(:group_session)
    user = create(:user)
    expect(group_session).to_not be_booked_by(user)
  end

  it 'is booked by users creating Bookings' do
    group_session = create(:group_session)
    user = create(:user)
    Booking.create(group_session, user)
    expect(group_session).to be_booked_by(user)
  end

  it 'is free when the price is 0' do
    group_session = build(:free_group_session)
    expect(group_session).to be_free
  end

  it 'is not free when the group session is priced' do
    group_session = build(:priced_group_session)
    expect(group_session).to_not be_free
  end
end
