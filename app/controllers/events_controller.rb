class EventsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']['credentials']
    CreateEvent.create(auth, current_user.group_sessions.last)
    flash[:info] = t('controllers.group_sessions.create.successful')
    redirect_to root_path
  end
end
