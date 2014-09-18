class GroupSessionsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]

  def index
    @live_sessions = load_sessions('starts_at <= ?', Time.current)
    @booked_sessions = current_user.booked_sessions
    @upcoming_sessions = load_sessions('starts_at > ?', Time.current)
  end

  def show
    load_session
  end

  def book
    load_session
    @group_session.add_participant(current_user)
    flash[:info] = t('controllers.group_sessions.book.successful')
    redirect_to :back
  end

  def new
    build_session
  end

  def create
    build_session
    save_session or render :new
  end

  def edit
    load_session
  end

  def update
    load_session
    build_session
    save_session(redirect: group_session_path(@group_session)) or render :edit
  end

  def destroy
    load_session
    destroy_session
  end

  private
  def build_session
    @group_session ||= group_scope.new
    @group_session.attributes = group_session_params
  end

  def save_session(options = { redirect: root_path })
    if @group_session.save
      redirect_to options[:redirect]
    end
  end

  def load_session
    @group_session = group_scope.find(params[:id])
  end

  def load_sessions(*args)
    @group_sessions = group_scope.where(*args)
  end

  def destroy_session
    @group_session.destroy
    redirect_to root_path
  end

  def group_scope
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
