require 'rails_helper'

describe SignupsController do
  describe 'POST #create' do
    it 'redirects the signup to the previous url' do
      session[:previous_url] = '/foo/bar'
      post :create, signup: { email: 'foo@bar.com', first_name: 'foo',
                              last_name: 'bar', password: 'secret83',
                              password_confirmation: 'secret83' }
      expect(response).to redirect_to('/foo/bar')
    end
  end
end
