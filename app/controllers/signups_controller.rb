class SignupsController < ApplicationController
  def new
    load_signup
  end

  def create
    build_signup
    save_signup {
      session[:user_id] = @signup.id
    } or render :new
  end

  private
  def load_signup
    @signup = Signup.new
  end

  def build_signup
    @signup ||= load_signup
    @signup.attributes = signup_attributes
  end

  def save_signup
    if @signup.save
      flash[:info] = t('controllers.signups.create.successful')
      yield if block_given?
      redirect_to root_path
    end
  end

  def signup_attributes
    if attributes = params[:signup]
      attributes.permit(:username, :password, :password_confirmation)
    else
      {}
    end
  end
end
