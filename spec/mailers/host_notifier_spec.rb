require 'rails_helper'

RSpec.describe HostNotifier do
  describe '.participant_joined' do
    it 'mails to the group session host' do
      user = double(:user)
      group_session = double(:group_session, host_email: 'host@example.com')

      mail = HostNotifier.participant_joined(group_session, user)

      expect(mail.to).to include('host@example.com')
    end
  end
end
