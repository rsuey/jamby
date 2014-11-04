class AddRemoteIdToGroupSessions < ActiveRecord::Migration
  def change
    add_column :group_sessions, :remote_id, :string
    add_index :group_sessions, :remote_id
  end
end
