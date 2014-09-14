require 'rails_helper'

describe User do
  describe '#booked_sessions' do
    it 'returns the booked group sessions assocation' do
      user = create(:user)
      group_session = create(:group_session)

      group_session.add_participant(user)

      expect(user.booked_sessions).to include(group_session)
    end
  end
end
