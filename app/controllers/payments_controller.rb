class PaymentsController < ApplicationController
  before_filter :authenticate_user!

  def confirm
    @account = current_account
    @group_session = GroupSession.find(params[:id])
    @payment_method = PaymentMethod.new
    @payment = Payment.new(group_session: @group_session, account: @account)
  end

  def create
    @group_session = GroupSession.find(payment_params[:group_session_id])
    set_payment_method
    @payment = Payment.new(payment_method: @payment_method,
                           group_session: @group_session,
                           account: current_account)
    if @payment.save
      @group_session.add_participant(current_user)
      flash[:info] = t('controllers.group_sessions.book.successful')
      redirect_to group_session_path(@group_session)
    else
      render :confirm
    end
  end

  private
  def set_payment_method
    if payment_method_params.values.all?(&:empty?)
      @payment_method = current_account.payment_methods
                                       .find(payment_params[:payment_method_id])
    else
      @payment_method = current_account.payment_methods
                                       .create(payment_method_params)
    end
  end

  def payment_params
    params.require(:payment).permit(:group_session_id, :payment_method_id)
  end

  def payment_method_params
    params.require(:payment_method).permit(:name_on_card, :number, :exp_month,
                                           :exp_year, :cvc)
  end
end
