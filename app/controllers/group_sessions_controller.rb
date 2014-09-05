class GroupSessionsController < ApplicationController
  def index
    @group_sessions = GroupSession.all
  end

  def new
    @group_session = GroupSession.new
  end

  def create
    GroupSession.create!(group_session_params)
    redirect_to root_path
  end

  private
  def group_session_params
    params.require(:group_session).permit(:title, :description, :price)
  end
end
