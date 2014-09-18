require 'rails_helper'

describe GroupSessionsController do
  describe 'before filter' do
    it 'stores location for index' do
      get :index
      expect(session[:previous_url]).to eq(group_sessions_path)
    end

    it 'stores location for new' do
      get :new
      expect(session[:previous_url]).to eq(new_group_session_path)
    end

    it 'stores location for show' do
      allow(controller).to receive(:load_session)
      get :show, id: 1
      expect(session[:previous_url]).to eq(group_session_path(1))
    end

    it 'stores location for edit' do
      get :edit, id: 1
      expect(session[:previous_url]).to eq(edit_group_session_path(1))
    end

    it 'stores location for book' do
      put :book, id: 1
      expect(session[:previous_url]).to eq(book_group_session_path(1))
    end
  end

  describe '#PUT book' do
    it 'redirects the user back to their referer' do
      user = create(:user)
      allow(controller).to receive(:current_user).and_return(user)
      request.env['HTTP_REFERER'] = '/foo/bar'
      group_session = create(:group_session)

      put :book, id: group_session.id
      expect(response).to redirect_to('/foo/bar')
    end
  end
end
