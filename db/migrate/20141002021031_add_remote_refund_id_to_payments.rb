class AddRemoteRefundIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :remote_refund_id, :string
  end
end
