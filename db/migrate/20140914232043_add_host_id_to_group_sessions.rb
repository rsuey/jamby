class AddHostIdToGroupSessions < ActiveRecord::Migration
  def change
    add_column :group_sessions, :host_id, :integer
    add_index :group_sessions, :host_id
  end
end
