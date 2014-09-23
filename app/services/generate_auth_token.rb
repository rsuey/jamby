class GenerateAuthToken
  def self.apply(client)
    begin
      client.auth_token ||= SecureRandom.urlsafe_base64
    end while client.class.exists?(auth_token: client.auth_token)
    client.save
  end
end
