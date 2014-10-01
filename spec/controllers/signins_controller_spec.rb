require 'rails_helper'

describe SigninsController do
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

    it 'requires authentication for destroy' do
      post :destroy
      expect(response).to redirect_to(signin_path)
      expect(flash[:info]).to eq(I18n.t('controllers.application.unauthenticated'))
    end
  end

  describe 'POST #create' do
    it 'redirects to the previous url' do
      session[:previous_url] = '/foo/bar'
      user = create(:signin)
      post :create, signin: { email: user.email, password: user.password }
      expect(response).to redirect_to('/foo/bar')
    end
  end
end
