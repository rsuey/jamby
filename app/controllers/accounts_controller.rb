class AccountsController < ApplicationController
  before_filter :store_location, except: :destroy

  def destroy
    current_user.destroy
    sign_out
    flash[:info] = t('controllers.accounts.destroy.successful')
    redirect_to root_path
  end
end
