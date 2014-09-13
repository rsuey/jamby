class ApplicationController < ActionController::Base
  rehearse_with 'jamby', 'joesak2k14'

  helper_method :current_user, :sign_in, :sign_out, :guest?

  protect_from_forgery with: :exception

  private
  def current_user
    @current_user ||= session[:user_id] && User.find_by(id: session[:user_id])
    @current_user ||= Guest.new
  end

  def guest?
    current_user.is_a?(Guest)
  end

  def sign_in(signin)
    session[:user_id] = signin.id
  end

  def sign_out
    session[:user_id] = nil
    @current_user = nil
  end
end
