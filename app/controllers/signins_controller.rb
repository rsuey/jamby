class SigninsController < ApplicationController
  def new
    build_signin
  end

  def create
    load_signin
    build_signin
    save_signin or render :new
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = t('controllers.signins.destroy.successful')
    redirect_to root_path
  end

  private
  def load_signin
    @signin = signin_scope.find_by(username: signin_params[:username])
  end

  def build_signin
    @signin ||= signin_scope.new
    @signin.attributes = signin_params
  end

  def save_signin
    if @signin.save
      sign_in(@signin)
      flash[:info] = t('controllers.signins.create.successful')
      redirect_to root_path
    end
  end

  def signin_params
    if attributes = params[:signin]
      attributes.permit(:username, :password)
    else
      {}
    end
  end

  def signin_scope
    Signin.where(nil)
  end
end
