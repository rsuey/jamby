require 'rails_helper'

RSpec.describe AccountMailer do
  describe '.password_reset' do
    it 'emails the user' do
      user = double(:user, email: 'user@example.org', password_reset_token: '')
      mail = AccountMailer.password_reset(user)
      expect(mail.to).to include('user@example.org')
    end

    it 'links them to the password page with their reset token' do
      user = double(:user, email: 'user@example.org',
                           password_reset_token: 'abc123')
      mail = AccountMailer.password_reset(user)
      expect(mail.body.encoded).to include('http://test.host/passwords/new?token=abc123')
    end
  end
end
