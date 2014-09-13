class ApplicationController < ActionController::Base
  helper_method :current_user

  protect_from_forgery with: :exception

  private
  def current_user
    (session[:user_id] && User.find_by(id: session[:user_id])) || Guest.new
  end
end
