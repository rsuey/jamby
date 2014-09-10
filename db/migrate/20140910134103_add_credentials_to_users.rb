class AddCredentialsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_index :users, :username
    add_column :users, :password_digest, :string
  end
end
