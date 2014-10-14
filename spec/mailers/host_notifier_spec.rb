require 'rails_helper'

RSpec.describe HostNotifier do
  describe '.participant_joined' do
    it 'mails to the group session host' do
      group_session = double(:group_session, title: 'Hi', host_email: 'host@example.com')

      mail = HostNotifier.participant_joined(group_session)

      expect(mail.to).to include('host@example.com')
    end
  end

  describe '.participant_canceled' do
    it 'mails to the group session host' do
      group_session = double(:group_session, title: 'Hi', host_email: 'host@example.com')

      mail = HostNotifier.participant_canceled(group_session)

      expect(mail.to).to include('host@example.com')
    end
  end
end
