class CreateGroupSessions < ActiveRecord::Migration
  def change
    create_table :group_sessions do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.datetime :starts_at, null: false
      t.decimal :price, precision: 5, scale: 2, null: false, default: 0

      t.timestamps
    end
  end
end
