require 'rails_helper'

describe SignupsController do
  describe 'before filter' do
    it 'requires no user for new' do
      user = create(:signup)
      allow(controller).to receive(:current_user) { user }
      get :new
      expect(response).to redirect_to(root_path)
      expect(flash[:info]).to eq(I18n.t('controllers.application.already_authenticated'))
    end

    it 'requires no user for create' do
      user = create(:signup)
      allow(controller).to receive(:current_user) { user }
      post :create
      expect(response).to redirect_to(root_path)
      expect(flash[:info]).to eq(I18n.t('controllers.application.already_authenticated'))
    end
  end

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
