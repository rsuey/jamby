class GenerateToken
  def self.apply(record, attribute)
    return true if record.send(attribute)
    begin
      record.send("#{attribute}=", SecureRandom.urlsafe_base64)
    end while record.class.exists?(attribute => record.send(attribute))
    record.save
  end
end
