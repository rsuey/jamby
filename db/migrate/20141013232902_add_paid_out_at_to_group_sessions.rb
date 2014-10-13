class AddPaidOutAtToGroupSessions < ActiveRecord::Migration
  def change
    add_column :group_sessions, :paid_out_at, :datetime
  end
end
