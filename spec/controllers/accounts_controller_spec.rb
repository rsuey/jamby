require 'rails_helper'

describe AccountsController do
  describe 'before filter' do
    it 'stores location for dashboard' do
      get :dashboard
      expect(session[:previous_url]).to eq(dashboard_account_path)
    end
  end
end
