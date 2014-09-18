require 'rails_helper'

describe SigninsController do
  describe 'POST #create' do
    it 'redirects to the previous url' do
      session[:previous_url] = '/foo/bar'
      user = create(:signin)
      post :create, signin: { email: user.email, password: user.password }
      expect(response).to redirect_to('/foo/bar')
    end
  end
end
