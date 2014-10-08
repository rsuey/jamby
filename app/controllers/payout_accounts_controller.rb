class PayoutAccountsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @payout_account = PayoutAccount.new
  end

  def create
    @payout_account = current_account.payout_accounts.new(payout_account_params)
    if @payout_account.save
      flash[:info] = t('controllers.payout_accounts.create.successful')
      redirect_to dashboard_account_path
    else
      render :new
    end
  end

  private
  def payout_account_params
    params.require(:payout_account).permit(:name, :country,
                                           :routing_number, :account_number)
  end
end
