class SigninsController < ApplicationController
  before_filter :require_no_user!, except: :destroy
  before_filter :authenticate_user!, only: :destroy

  def new
    build_signin
  end

  def create
    load_signin
    build_signin
    save_signin || fail_and_try_again
  end

  def destroy
    sign_out
    flash[:info] = t('controllers.signins.destroy.successful')
    redirect_to root_path
  end

  private
  def fail_and_try_again
    flash.now[:alert] = t('controllers.signins.create.failure')
    render :new
  end

  def load_signin
    @signin = signin_scope.find_by(email: signin_params[:email])
  end

  def build_signin
    @signin ||= signin_scope.new
    @signin.attributes = signin_params
  end

  def save_signin
    if @signin.save
      flash[:info] = t('controllers.signins.create.successful')
      sign_in(@signin)
    end
  end

  def signin_params
    if attributes = params[:signin]
      attributes.permit(:email, :password)
    else
      {}
    end
  end

  def signin_scope
    Signin.not_deleted
  end
end
