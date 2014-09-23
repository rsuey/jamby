class ApplicationController < ActionController::Base
  rehearse_with 'jamby', 'joesak2k14'

  helper_method :current_user

  protect_from_forgery with: :exception

  private
  def authenticate_user!
    if current_user.is_guest?
      flash[:info] = t('controllers.application.unauthenticated')
      redirect_to signin_path
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
    session[:auth_token] = signin.auth_token
    redirect_to session[:previous_url] || root_path
  end

  def sign_out
    session[:auth_token] = nil
    @current_user = nil
  end

  def store_location
    session[:previous_url] = request.fullpath
  end

  def find_or_guest(klass)
    session[:auth_token] &&
      klass.find_by(auth_token: session[:auth_token]) ||
        Guest.new
  end
end
