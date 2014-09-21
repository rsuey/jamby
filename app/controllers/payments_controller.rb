class PaymentsController < ApplicationController
  before_filter :authenticate_user!

  def confirm
    group_session = GroupSession.find(params[:id])
    @payment = Payment.new(group_session: group_session, user: current_user)
  end

  def create
    group_session = GroupSession.find(payment_params[:group_session_id])
    payment_method = current_user.payment_methods
                                 .find(payment_params[:payment_method_id])
    @payment = Payment.new(payment_method: payment_method,
                           group_session: group_session,
                           user: current_user)
    if @payment.save
      group_session.add_participant(current_user)
      flash[:info] = t('controllers.group_sessions.book.successful')
      redirect_to group_session_path(group_session)
    else
      render :new
    end
  end

  private
  def payment_params
    params.require(:payment).permit(:group_session_id, :payment_method_id)
  end
end
