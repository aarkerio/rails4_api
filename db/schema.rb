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

ActiveRecord::Schema.define(version: 20151007162521) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.string   "api_key",       null: false
    t.string   "secret_key"
    t.boolean  "active"
    t.string   "db_name"
    t.string   "db_user"
    t.string   "db_pwd"
    t.string   "db_staging"
    t.string   "db_production"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "fname"
    t.string   "lname"
    t.string   "uname"
    t.string   "email",      null: false
    t.string   "guid",       null: false
    t.string   "passwd",     null: false
    t.boolean  "active"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["group_id"], name: "index_users_on_group_id", using: :btree

  add_foreign_key "users", "groups"
end
