require 'rails_helper'

describe Signin do
  describe '#save' do
    it 'authenticates the user' do
      user = create(:signin, password: 'secret83')
      allow(user).to receive(:authenticate)
      user.save
      expect(user).to have_received(:authenticate).with('secret83')
    end
  end
end
