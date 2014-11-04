class EventsController < ApplicationController
  before_filter :authenticate_user!

  def create
    group_session = current_user.group_sessions.last
    CreateEvent.create(group_session)
    flash[:info] = t('controllers.group_sessions.create.successful')
    redirect_to root_path
  end
end
