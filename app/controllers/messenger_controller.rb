class MessengerController < ApplicationController
  skip_before_filter :require_http_basic_auth, only: :auth
  protect_from_forgery except: :auth

  def auth
    if current_user
      auth = Messenger.authenticate(params[:channel_name], params[:socket_id])
      render json: auth
    else
      render text: 'Forbidden', status: 403
    end
  end
end
