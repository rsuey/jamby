require 'rails_helper'

describe Booking do
  it 'does not create duplicates' do
    user = create(:user)
    group_session = create(:group_session)
    2.times { Booking.create(group_session, user) }
    expect(Booking.count).to eq(1)
  end

  it 'destroys bookings' do
    user = create(:user)
    group_session = create(:group_session)

    Booking.create(group_session, user)
    Booking.destroy(group_session, user)

    expect(Booking.count).to eq(0)
  end
end
