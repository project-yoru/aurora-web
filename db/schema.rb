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

ActiveRecord::Schema.define(version: 20160604072249) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "pgcrypto"
  enable_extension "uuid-ossp"

  create_table "distributions", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "platform",                                 null: false
    t.string   "state",            default: "initialized", null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "url"
    t.string   "progress_message"
  end

  add_index "distributions", ["project_id"], name: "index_distributions_on_project_id", using: :btree

  create_table "oauth_accesses", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "access_token"
    t.datetime "expires_at"
    t.string   "refresh_token"
    t.string   "user_name"
    t.string   "profile_url"
    t.string   "profile_name"
    t.string   "avatar_url"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
  end

  add_index "oauth_accesses", ["provider", "uid"], name: "index_oauth_accesses_on_provider_and_uid", unique: true, using: :btree
  add_index "oauth_accesses", ["user_id"], name: "index_oauth_accesses_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",                       null: false
    t.string   "git_repo_path",              null: false
    t.string   "platforms",                               array: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.jsonb    "config",        default: {}
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "encrypted_password", default: "", null: false
    t.integer  "sign_in_count",      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "distributions", "projects"
  add_foreign_key "oauth_accesses", "users"
  add_foreign_key "projects", "users"
end
