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

ActiveRecord::Schema.define(version: 20170628103340) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "department_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "groups", ["department_id"], name: "index_groups_on_department_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "number"
    t.string   "name"
    t.string   "hashed_password"
    t.integer  "year"
    t.integer  "group_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["group_id"], name: "index_users_on_group_id", using: :btree

  create_table "words", force: :cascade do |t|
    t.string   "name"
    t.string   "desc"
    t.string   "user"
    t.boolean  "removed",    default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "words", ["user"], name: "index_words_on_user", using: :btree

  add_foreign_key "groups", "departments"
  add_foreign_key "users", "groups"
end
