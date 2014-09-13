class SignupsController < ApplicationController
  def new
    load_signup
  end

  def create
    build_signup
    save_signup or render :new
  end

  private
  def load_signup
    @signup = signup_scope.new
  end

  def build_signup
    @signup ||= load_signup
    @signup.attributes = signup_params
  end

  def save_signup
    if @signup.save
      session[:user_id] = @signup.id
      flash[:info] = t('controllers.signups.create.successful')
      redirect_to root_path
    end
  end

  def signup_scope
    Signup.where(nil)
  end

  def signup_params
    params.require(:signup).permit(:username,
                                   :password,
                                   :password_confirmation)
  end
end
