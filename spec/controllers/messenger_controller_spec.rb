require 'rails_helper'

describe MessengerController do
  describe 'POST #auth' do
    it 'rejects unauthenticated requests' do
      allow(controller).to receive(:current_user) { false }
      post :auth
      expect(response.code).to eq('403')
      expect(response.body).to eq('Forbidden')
    end

    it 'returns the pusher response for authenticated requests' do
      user = create(:user)

      allow(controller).to receive(:current_user) { user }
      allow(Messenger).to receive(:authenticate) { { auth: 'something' } }

      post :auth, channel_name: 'name', socket_id: 'socket'

      expect(response).to be_successful
      expect(JSON.parse(response.body)['auth']).to eq('something')
    end
  end
end
