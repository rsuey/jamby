class Guest < ActiveType::Record[User]
  def username
    'guest'
  end
end
