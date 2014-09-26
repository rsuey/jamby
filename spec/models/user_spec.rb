require 'rails_helper'

describe User do
  describe '#booked_sessions' do
    it 'returns the booked group sessions assocation' do
      user = create(:user)
      group_session = create(:group_session)

      Booking.create(group_session, user)

      expect(user.booked_sessions).to include(group_session)
    end
  end

  describe '#is_guest?' do
    it 'returns false' do
      expect(User.new).to_not be_is_guest
    end
  end
end
