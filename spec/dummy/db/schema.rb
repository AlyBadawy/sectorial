# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_05_24_210207) do
  create_table "securial_role_assignments", id: :string, force: :cascade do |t|
    t.string "user_id", null: false
    t.string "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_securial_role_assignments_on_role_id"
    t.index ["user_id"], name: "index_securial_role_assignments_on_user_id"
  end

  create_table "securial_roles", id: :string, force: :cascade do |t|
    t.string "role_name"
    t.boolean "hide_from_profile", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_name"], name: "index_securial_roles_on_role_name", unique: true
  end

  create_table "securial_sessions", id: :string, force: :cascade do |t|
    t.string "user_id", null: false
    t.string "ip_address", null: false
    t.string "user_agent", null: false
    t.string "refresh_token", null: false
    t.integer "refresh_count", default: 0
    t.datetime "last_refreshed_at"
    t.datetime "refresh_token_expires_at"
    t.boolean "revoked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_securial_sessions_on_user_id"
  end

  create_table "securial_users", id: :string, force: :cascade do |t|
    t.string "email_address"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "username"
    t.string "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_created_at"
    t.index ["email_address"], name: "index_securial_users_on_email_address", unique: true
    t.index ["username"], name: "index_securial_users_on_username", unique: true
  end

  add_foreign_key "securial_role_assignments", "securial_roles", column: "role_id"
  add_foreign_key "securial_role_assignments", "securial_users", column: "user_id"
  add_foreign_key "securial_sessions", "securial_users", column: "user_id"
end
