class ApplicationController < ActionController::Base
  helper_method :current_user

  protect_from_forgery with: :exception

  private
  def current_user
    if session[:user_id] && user = User.find_by(id: session[:user_id])
      user
    else
      Guest.new
    end
  end
end
