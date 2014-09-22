class AccountsController < ApplicationController
  before_filter :store_location, except: :destroy

  def dashboard
    @account = current_account
  end

  def edit
    @account = current_account
  end

  def update
    @account = current_account
    if @account.update_attributes(account_params)
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
    params.require(:account).permit(:first_name, :last_name)
  end
end
