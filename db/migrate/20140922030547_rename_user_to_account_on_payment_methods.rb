class RenameUserToAccountOnPaymentMethods < ActiveRecord::Migration
  def change
    rename_column :payment_methods, :user_id, :account_id
  end
end
