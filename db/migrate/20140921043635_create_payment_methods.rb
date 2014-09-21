class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.integer :last4, null: false
      t.integer :exp_month, null: false
      t.integer :exp_year, null: false
      t.string :remote_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
    add_index :payment_methods, :remote_id, unique: true
    add_index :payment_methods, :user_id
  end
end
