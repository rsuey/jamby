require './app/services/messenger'

describe Messenger do
  describe '.authenticate' do
    it 'authenticates with Pusher' do
      pusher = double(:pusher)

      allow(Pusher).to receive_message_chain(:[]) { pusher }
      allow(pusher).to receive(:authenticate)

      Messenger.authenticate('channel', 'socket')

      expect(Pusher).to have_received(:[]).with('channel')
      expect(pusher).to have_received(:authenticate).with('socket')
    end
  end

  describe '.notify' do
    it 'passes messages on to Pusher' do
      client = double(:client, id: 1)

      allow(Pusher).to receive(:trigger)

      Messenger.notify(client, 'event', { hash: 'payload' })

      expect(Pusher).to have_received(:trigger)
                        .with('private-1', 'event', { hash: 'payload' })
    end
  end
end
