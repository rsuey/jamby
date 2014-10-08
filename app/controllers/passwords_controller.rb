class PasswordsController < ApplicationController
  before_filter :require_no_user!

  def new
    @password = Password.new
  end

  def create
    account = Account.find_by(password_reset_token: password_params[:token])
    if account && account.update_attributes(password_reset_params)
      sign_in(account)
    else
      @password = Password.new
      @password.errors.add(:base, 'Please try that again')
      render :new
    end
  end

  private
  def password_params
    params.require(:password).permit(:token)
  end

  def password_reset_params
    params.require(:password).permit(:password, :password_confirmation)
  end
end
