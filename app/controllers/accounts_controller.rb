class AccountsController < ApplicationController
  before_filter :store_location, except: :destroy
  before_filter :authenticate_user!

  def dashboard
    @account = current_account
  end

  def my_sessions
    @booked_sessions = current_account.booked_sessions.not_completed
    @hosted_sessions = current_account.group_sessions.not_completed
  end

  def edit
    @account = current_account
  end

  def update
    @account = current_account

    if @account.update_attributes(account_params)
      flash[:info] = t('controllers.accounts.update.successful')
      redirect_to dashboard_account_path
    else
      render :edit
    end
  end

  def destroy
    current_account.destroy
    sign_out
    flash[:info] = t('controllers.accounts.destroy.successful')
    redirect_to root_path
  end

  private
  def account_params
    params.require(:account).permit(:email, :first_name, :last_name, :password,
                                    :current_password, :password_confirmation,
                                    :time_zone, :avatar)
  end
end
