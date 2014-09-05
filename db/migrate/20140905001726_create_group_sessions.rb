class CreateGroupSessions < ActiveRecord::Migration
  def change
    create_table :group_sessions do |t|
      t.string :title
      t.text :description
      t.decimal :price, precision: 5, scale: 2, null: false, default: 0

      t.timestamps
    end
  end
end
