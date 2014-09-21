class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :amount
      t.string :currency
      t.references :user, index: true
      t.references :group_session, index: true
      t.string :remote_id

      t.timestamps
    end
    add_index :payments, :remote_id
  end
end
