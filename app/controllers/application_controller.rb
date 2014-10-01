class ApplicationController < ActionController::Base
  rehearse_with 'jamby', 'joesak2k14'

  around_filter :user_time_zone, if: :current_user

  helper_method :current_user

  protect_from_forgery with: :exception

  private
  def authenticate_user!
    if current_user.is_guest?
      flash[:info] = t('controllers.application.unauthenticated')
      redirect_to signin_path
    end
  end

  def require_no_user!
    unless current_user.is_guest?
      flash[:info] = t('controllers.application.already_authenticated')
      redirect_to root_path
    end
  end

  def current_user
    @current_user ||= find_or_guest(User)
  end

  def current_account
    @current_account ||= find_or_guest(Account)
  end

  def sign_in(signin)
    GenerateAuthToken.apply(signin)
    if params[:remember_me]
      cookies.permanent[:auth_token] = signin.auth_token
    else
      cookies[:auth_token] = signin.auth_token
    end
    redirect_to session[:previous_url] || root_path
  end

  def sign_out
    cookies.delete(:auth_token)
    @current_user = nil
  end

  def store_location
    session[:previous_url] = request.fullpath
  end

  def find_or_guest(klass)
    cookies[:auth_token] &&
      klass.find_by(auth_token: cookies[:auth_token]) ||
        Guest.new
  end

  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
