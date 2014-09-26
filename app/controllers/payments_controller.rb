class PaymentsController < ApplicationController
  before_filter :authenticate_user!

  def confirm
    @group_session = GroupSession.find(params[:id])
    @payment_methods = current_account.payment_methods
    @payment_method = PaymentMethod.new
    @payment = @group_session.payments.build
  end

  def create
    @group_session = GroupSession.find(group_session_id)
    @payment_method = PaymentMethodFactory.find_or_create(payment_method_params,
                                                          existing_payment_method_id,
                                                          current_account)
    @payment = @group_session.payments.build(payment_method: @payment_method,
                                             account: current_account)
    if @payment.save
      Booking.create(@group_session, current_user)
      flash[:info] = t('controllers.group_sessions.book.successful')
      redirect_to group_session_path(@group_session)
    else
      render :confirm
    end
  end

  private
  def payment_params
    params.require(:payment).permit(:group_session_id, :payment_method_id)
  end

  def payment_method_params
    params[:payment_method].permit(:name_on_card, :number, :exp_month,
                                   :exp_year, :cvc)
  end

  def existing_payment_method_id
    payment_params[:payment_method_id]
  end

  def group_session_id
    payment_params[:group_session_id]
  end
end
