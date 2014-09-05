class GroupSessionsController < ApplicationController
  def index
    load_sessions
  end

  def new
    build_session
  end

  def create
    build_session
    save_session or render :new
  end

  private
  def build_session
    @group_session = group_scope.new
    @group_session.attributes = group_session_params
  end

  def save_session
    if @group_session.save
      redirect_to root_path
    end
  end

  def load_sessions
    @group_sessions = group_scope.all
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
