class AddEndedAtToGroupSessions < ActiveRecord::Migration
  def change
    add_column :group_sessions, :ended_at, :datetime
    add_index :group_sessions, :ended_at
  end
end
