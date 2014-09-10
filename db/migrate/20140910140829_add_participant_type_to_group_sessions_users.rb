class AddParticipantTypeToGroupSessionsUsers < ActiveRecord::Migration
  def change
    add_column :group_sessions_users, :participant_type, :string
  end
end
