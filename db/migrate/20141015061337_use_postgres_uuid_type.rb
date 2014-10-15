class UsePostgresUuidType < ActiveRecord::Migration
  def change
    User.where('auth_token IS NOT NULL').find_each { |u| u.update_attributes(auth_token: nil) }
    User.where('password_reset_token IS NOT NULL').find_each { |u| u.update_attributes(password_reset_token: nil) }
    GroupSession.where('hashed_id IS NOT NULL').find_each { |u| u.update_attributes(hashed_id: nil) }

    execute 'create extension "uuid-ossp"'

    change_column :users, :auth_token, 'uuid USING CAST(auth_token as uuid)', default: 'uuid_generate_v4()'
    change_column :users, :password_reset_token, 'uuid USING CAST(password_reset_token as uuid)', default: 'uuid_generate_v4()'
    change_column :group_sessions, :hashed_id, 'uuid USING CAST(hashed_id as uuid)', default: 'uuid_generate_v4()'

    add_index :users, [:password_reset_token], unique: true
  end
end
