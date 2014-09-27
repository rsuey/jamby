class GenerateAuthToken
  def self.apply(client)
    return true if client.auth_token
    begin
      client.auth_token = SecureRandom.urlsafe_base64
    end while client.class.exists?(auth_token: client.auth_token)
    client.save
  end
end
