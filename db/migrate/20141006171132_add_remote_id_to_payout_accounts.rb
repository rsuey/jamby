class AddRemoteIdToPayoutAccounts < ActiveRecord::Migration
  def change
    add_column :payout_accounts, :remote_id, :string
  end
end
