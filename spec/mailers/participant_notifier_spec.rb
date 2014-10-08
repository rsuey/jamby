require 'rails_helper'

RSpec.describe ParticipantNotifier do
  describe '.group_session_booked' do
    it 'emails the participant' do
      user = double(:user, email: 'user@example.com')
      group_session = double(:group_session)

      mail = ParticipantNotifier.group_session_booked(group_session, user)

      expect(mail.to).to include('user@example.com')
    end
  end

  describe '.booking_canceled' do
    it 'emails the participant' do
      user = double(:user, email: 'user@example.com')
      group_session = double(:group_session)

      mail = ParticipantNotifier.booking_canceled(group_session, user)

      expect(mail.to).to include('user@example.com')
    end
  end
end
