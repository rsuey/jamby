class GroupSessionsController < ApplicationController
  skip_before_filter :require_http_basic_auth, only: [:ready, :ping]
  protect_from_forgery except: [:ready, :ping]

  before_filter :store_location, except: [:create, :update, :destroy,
                                          :ready, :ping]
  before_filter :authenticate_user!, except: [:index, :show, :ready, :ping]

  def index
    @live_sessions = group_session_scope.live
    @booked_sessions = current_user.booked_sessions
    @upcoming_sessions = group_session_scope.upcoming
  end

  def show
    @group_session = group_session_scope.find(params[:id])
  end

  def book
    @group_session = group_session_scope.find(params[:id])
    if @group_session.paid?(current_account)
      Booking.create(@group_session, current_user)
      flash[:info] = t('controllers.group_sessions.book.successful')
      redirect_to after_successful_booking_path
    elsif @group_session.can_be_booked_by?(current_user)
      flash[:info] = t('controllers.group_sessions.book.please_confirm')
      redirect_to confirm_payment_path(@group_session)
    else
      flash[:alert] = t('controllers.group_sessions.book.cannot_book')
      redirect_to after_failed_booking_path
    end
  end

  def cancel_booking
    @group_session = group_session_scope.find(params[:id])
    Booking.destroy(@group_session, current_user)
    if payment = @group_session.payments.find_by(account_id: current_account.id)
      payment.destroy
    end
    flash[:info] = t('controllers.group_sessions.cancel_booking.successful')
    redirect_to after_successful_booking_path
  end

  def new
    @group_session = group_session_scope.new
  end

  def create
    @group_session = group_session_scope.new(group_session_params)
    if @group_session.save
      flash[:info] = t('controllers.group_sessions.create.successful')
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @group_session = group_session_scope.find(params[:id])
    unless @group_session.host == current_user
      flash[:alert] = t('controllers.application.unauthorized')
      redirect_to root_path
    end
  end

  def update
    @group_session = group_session_scope.find(params[:id])
    if @group_session.update_attributes(group_session_params)
      redirect_to @group_session
    else
      render :edit
    end
  end

  def ready
    group_session = GroupSession.find(params[:id])
    Messenger.notify(group_session, 'session_is_live',
                                    { url: params[:hangoutUrl],
                                      youtubeId: params[:youtubeId] })
    group_session.update_attributes(live_url: params[:hangoutUrl],
                                    broadcast_id: params[:youtubeId])
    render nothing: true
  end

  def ping
    group_session = GroupSession.find(params[:id])
    CompleteGroupSessionWorker.reschedule(group_session.completion_job_id)
    render nothing: true
  end

  def destroy
    @group_session = group_session_scope.find(params[:id])
    if @group_session.host == current_user
      @group_session.destroy
      flash[:info] = t('controllers.group_sessions.destroy.successful')
    else
      flash[:alert] = t('controllers.application.unauthorized')
    end
    redirect_to root_path
  end

  private
  def after_successful_booking_path
    if previous_page_is_missing_or_signing_in_or_signing_up?
      @group_session
    else
      :back
    end
  end

  def after_failed_booking_path
    after_successful_booking_path
  end

  def previous_page_is_missing_or_signing_in_or_signing_up?
    [nil, '', signin_path, signup_path].include?(request.env['HTTP_REFERER'])
  end

  def group_session_scope
    GroupSession.not_deleted.includes(:host, :participants).where(nil)
  end

  def group_session_params
    parameters = if attributes = params[:group_session]
                   attributes.permit(:title, :description, :starts_at, :price)
                 else
                   {}
                 end
    parameters.merge(host: current_user)
  end
end
