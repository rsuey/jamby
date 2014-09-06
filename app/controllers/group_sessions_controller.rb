class GroupSessionsController < ApplicationController
  def index
    load_sessions
  end

  def show
    load_session
  end

  def book
    load_session
    @group_session.add_participant(current_user)
    flash[:info] = t('controllers.group_sessions.book.successful')
    redirect_to group_session_path(@group_session)
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

  def load_sessions
    @group_sessions = group_scope.not_deleted
  end

  def destroy_session
    @group_session.destroy
    redirect_to root_path
  end

  def group_scope
    GroupSession.where(nil)
  end

  def group_session_params
    if attributes = params[:group_session]
      attributes.permit(:title, :description, :starts_at, :price)
    else
      {}
    end
  end
end
