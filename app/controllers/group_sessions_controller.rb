class GroupSessionsController < ApplicationController
  before_filter :store_location, except: [:create, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :show]

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
      @group_session.add_participant(current_user)
      flash[:info] = t('controllers.group_sessions.book.successful')
      redirect_to :back
    else
      redirect_to confirm_payment_path(@group_session)
    end
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
  def group_session_scope
    GroupSession.not_deleted.where(nil)
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
