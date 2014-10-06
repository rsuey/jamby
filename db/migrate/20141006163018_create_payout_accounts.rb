class CreatePayoutAccounts < ActiveRecord::Migration
  def change
    create_table :payout_accounts do |t|
      t.string :name
      t.string :bank_name
      t.integer :last4
      t.string :account_type

      t.timestamps
    end
  end
end
