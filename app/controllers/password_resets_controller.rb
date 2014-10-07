class PasswordResetsController < ApplicationController
  def new
    @password_reset = PasswordReset.new
  end

  def create
    if account = Account.find_by(email: params[:password_reset][:email])
      GenerateToken.apply(account, :password_reset_token)
      flash[:info] = t('controllers.password_resets.create.successful')
      redirect_to root_path
    else
      @password_reset.errors.add(:base, "Email address not found")
      render :new
    end
  end
end
