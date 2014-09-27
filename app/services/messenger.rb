require 'pusher'

class Messenger
  class << self
    def notify(client, event, payload)
      @client = client
      Pusher.trigger(channel_name, event, payload)
    end

    def authenticate(channel, socket)
      Pusher[channel].authenticate(socket)
    end

    def channel_id(client)
      @client = client
      channel_name
    end

    private
    attr_accessor :client

    def channel_name
      "private-#{client.id}"
    end
  end
end
