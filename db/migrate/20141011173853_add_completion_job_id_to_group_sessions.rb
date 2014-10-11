class AddCompletionJobIdToGroupSessions < ActiveRecord::Migration
  def change
    add_column :group_sessions, :completion_job_id, :string
    add_index :group_sessions, :completion_job_id
  end
end
