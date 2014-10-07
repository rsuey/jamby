class GenerateAuthToken
  def self.apply(client)
    GenerateToken.apply(client, :auth_token)
  end
end
