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

ActiveRecord::Schema[7.1].define(version: 2024_09_11_173716) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campaigns", force: :cascade do |t|
    t.bigint "receiving_wallet_id", null: false
    t.string "title", null: false
    t.text "description"
    t.text "accepted_currencies", default: [], array: true
    t.string "tier_name"
    t.decimal "tier_amount", precision: 10, scale: 2
    t.string "contribution_cadence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "repository_id", null: false
    t.index ["receiving_wallet_id"], name: "index_campaigns_on_receiving_wallet_id"
    t.index ["repository_id"], name: "index_campaigns_on_repository_id"
  end

  create_table "contributions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "campaign_id", null: false
    t.bigint "sending_wallet_id", null: false
    t.string "contribution_cadence"
    t.decimal "amount", precision: 10, scale: 2
    t.string "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_contributions_on_campaign_id"
    t.index ["sending_wallet_id"], name: "index_contributions_on_sending_wallet_id"
    t.index ["user_id"], name: "index_contributions_on_user_id"
  end

  create_table "repositories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "repo_github_id"
    t.string "full_name"
    t.string "name"
    t.string "owner_login"
    t.string "html_url"
    t.text "description"
    t.boolean "private"
    t.boolean "fork"
    t.datetime "created_on_github_at"
    t.datetime "updated_on_github_at"
    t.datetime "pushed_to_github_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["full_name"], name: "index_repositories_on_full_name"
    t.index ["user_id"], name: "index_repositories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "nickname"
    t.string "avatar_url"
    t.string "github_access_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "address"
    t.integer "chain_id"
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  add_foreign_key "campaigns", "repositories"
  add_foreign_key "campaigns", "wallets", column: "receiving_wallet_id"
  add_foreign_key "contributions", "campaigns"
  add_foreign_key "contributions", "users"
  add_foreign_key "contributions", "wallets", column: "sending_wallet_id"
  add_foreign_key "repositories", "users"
  add_foreign_key "wallets", "users"
end
