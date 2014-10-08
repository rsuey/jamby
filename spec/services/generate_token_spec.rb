require 'ostruct'
require './app/services/generate_token'

describe GenerateToken do
  describe '.apply' do
    it 'adds a token to the client' do
      client = double(:client)

      allow(client).to receive_message_chain(:class, exists?: false)
      allow(client).to receive(:auth_token) { nil }
      allow(client).to receive(:save)

      allow(client).to receive(:auth_token=)
      allow(SecureRandom).to receive(:urlsafe_base64) { '123abc' }

      GenerateToken.apply(client, :auth_token)
      expect(client).to have_received(:auth_token=).with('123abc')
    end

    it 'finds another random string when the generated one exists' do
      client = double(:client)

      allow(client).to receive_message_chain(:class, :exists?).and_return(true, false)
      allow(client).to receive(:auth_token) { nil }
      allow(client).to receive(:save)

      allow(client).to receive(:auth_token=)
      allow(SecureRandom).to receive(:urlsafe_base64).and_return('123abc', '456def')

      GenerateToken.apply(client, :auth_token)
      expect(client).to have_received(:auth_token=).with('456def')
    end

    it 'returns early when the client already has a token' do
      client = double(:client, auth_token: '123abc')
      # checking for the infinite loop bug here
      allow(client).to receive_message_chain(:class, :exists?) { true }
      expect(GenerateToken.apply(client, :auth_token)).to be_truthy
    end
  end
end
