class CreateGroupSessionsUsers < ActiveRecord::Migration
  def change
    create_table :group_sessions_users do |t|
      t.references :participant, index: true
      t.references :group_session, index: true

      t.timestamps
    end
  end
end
