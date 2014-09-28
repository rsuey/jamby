class AddLiveDetailsToGroupSessions < ActiveRecord::Migration
  def change
    add_column :group_sessions, :live_url, :string
    add_column :group_sessions, :broadcast_id, :string
  end
end
