class RenameUserToAccountOnPayments < ActiveRecord::Migration
  def change
    rename_column :payments, :user_id, :account_id
  end
end
