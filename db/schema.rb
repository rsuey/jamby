# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140910140829) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "group_sessions", force: true do |t|
    t.string   "title",                                             null: false
    t.text     "description",                                       null: false
    t.datetime "starts_at",                                         null: false
    t.decimal  "price",       precision: 5, scale: 2, default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "group_sessions", ["deleted_at"], name: "index_group_sessions_on_deleted_at", using: :btree

  create_table "group_sessions_users", force: true do |t|
    t.integer  "participant_id"
    t.integer  "group_session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "participant_type"
  end

  add_index "group_sessions_users", ["group_session_id"], name: "index_group_sessions_users_on_group_session_id", using: :btree
  add_index "group_sessions_users", ["participant_id"], name: "index_group_sessions_users_on_participant_id", using: :btree

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "password_digest"
  end

  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
