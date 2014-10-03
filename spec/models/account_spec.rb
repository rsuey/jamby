require 'rails_helper'

describe Account do
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
