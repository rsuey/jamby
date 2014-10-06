class AddAccountsToPayoutAccounts < ActiveRecord::Migration
  def change
    add_column :payout_accounts, :account_id, :integer
    add_index :payout_accounts, :account_id
  end
end
