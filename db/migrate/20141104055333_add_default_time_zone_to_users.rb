class AddDefaultTimeZoneToUsers < ActiveRecord::Migration
  def change
    change_column :users, :time_zone, :string, default: 'Pacific Time (US & Canada)'
  end
end
