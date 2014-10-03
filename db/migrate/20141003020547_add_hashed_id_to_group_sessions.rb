class AddHashedIdToGroupSessions < ActiveRecord::Migration
  def change
    add_column :group_sessions, :hashed_id, :string
    add_index :group_sessions, :hashed_id, unique: true
  end
end
