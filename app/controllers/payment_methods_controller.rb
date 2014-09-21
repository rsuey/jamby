class PaymentMethodsController < ApplicationController
  before_filter :store_location, except: :create
  before_filter :authenticate_user!

  def new
    @payment_method = PaymentMethod.new
  end

  def create
    @payment_method = current_user.payment_methods.new(payment_method_params)
    if @payment_method.save
      flash[:info] = t('controllers.payment_methods.create.successful')
      redirect_to dashboard_account_path
    else
      render :new
    end
  end

  def edit
    @payment_method = current_user.payment_methods.find(params[:id])
  end

  def update
    @payment_method = current_user.payment_methods.find(params[:id])
    if @payment_method.update_attributes(payment_method_params)
      redirect_to dashboard_account_path
    else
      render :edit
    end
  end

  private
  def payment_method_params
    params.require(:payment_method).permit(:name_on_card, :number, :exp_month,
                                           :exp_year, :cvc)
  end
end