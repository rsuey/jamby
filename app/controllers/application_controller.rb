class ApplicationController < ActionController::Base
  helper_method :current_user

  protect_from_forgery with: :exception

  private
  def current_user
    Participant.last
  end
end
