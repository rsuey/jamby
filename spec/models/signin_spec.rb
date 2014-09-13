require 'rails_helper'

describe Signin do
  describe '#save' do
    it 'authenticates the user' do
      signin = create(:signin, password: 'secret83')
      allow(signin).to receive(:authenticate)
      signin.save
      expect(signin).to have_received(:authenticate).with('secret83')
    end
  end
end
