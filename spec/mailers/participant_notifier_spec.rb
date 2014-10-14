require 'rails_helper'

RSpec.describe ParticipantNotifier do
  describe '.group_session_booked' do
    it 'emails the participant' do
      user = double(:user, time_zone: 'Eastern Time (US & Canada)',
                           email: 'user@example.com')
      group_session = double(:group_session, title: 'price reduction',
                                             starts_at: Time.current + 1.hour)

      mail = ParticipantNotifier.group_session_booked(group_session, user)

      expect(mail.to).to include('user@example.com')
    end
  end

  describe '.booking_canceled' do
    it 'emails the participant' do
      user = double(:user, email: 'user@example.com')
      group_session = double(:group_session, title: 'price reduction')

      mail = ParticipantNotifier.booking_canceled(group_session, user)

      expect(mail.to).to include('user@example.com')
    end
  end

  describe '.price_reduced' do
    it 'emails the participant' do
      user = double(:user, email: 'user@example.com')
      group_session = double(:group_session, title: 'price reduction',
                                             price: 8)

      mail = ParticipantNotifier.price_reduced(group_session, user, 10) # price_was 10

      expect(mail.to).to include('user@example.com')
    end
  end
end
