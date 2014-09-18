require 'rails_helper'

describe GroupSessionsController do
  describe '#PUT book' do
    it 'redirects the user back to their referrer' do
      user = create(:user)
      allow(controller).to receive(:current_user).and_return(user)
      request.env['HTTP_REFERER'] = '/foo/bar'
      group_session = create(:group_session)

      put :book, id: group_session.id
      expect(response).to redirect_to('/foo/bar')
    end
  end
end
