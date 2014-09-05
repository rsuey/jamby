class AddDeletedAtToGroupSessions < ActiveRecord::Migration
  def change
    add_column :group_sessions, :deleted_at, :datetime
    add_index :group_sessions, :deleted_at
  end
end
