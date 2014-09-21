class ApplicationController < ActionController::Base
  rehearse_with 'jamby', 'joesak2k14'

  helper_method :authenticate_user!, :current_user, :sign_in, :sign_out,
    :store_location

  protect_from_forgery with: :exception

  private
  def authenticate_user!
    if current_user.is_guest?
      flash[:info] = t('controllers.application.unauthenticated')
      redirect_to signin_path
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
    @current_user ||= Guest.new
  end

  def sign_in(signin)
    session[:user_id] = signin.id
    redirect_to session[:previous_url] || root_path
  end

  def sign_out
    session[:user_id] = nil
    @current_user = nil
  end

  def store_location
    session[:previous_url] = request.fullpath
  end
end
