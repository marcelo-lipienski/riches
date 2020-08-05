# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_05_225154) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "number"
    t.string "agency"
    t.decimal "balance", precision: 8, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.decimal "limit", precision: 8, scale: 2, default: "0.0"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "country"
    t.string "state"
    t.string "city"
    t.string "district"
    t.string "street"
    t.string "number"
    t.string "complement"
    t.string "zip_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "transaction_type"
    t.decimal "amount", precision: 8, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "source_account_id"
    t.integer "destination_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "fullname"
    t.string "document"
    t.date "birthdate"
    t.integer "gender"
    t.string "password"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
  end

  create_table "withdrawal_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "account_id", null: false
    t.decimal "amount", precision: 8, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_withdrawal_requests_on_account_id"
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "addresses", "users"
  add_foreign_key "withdrawal_requests", "accounts"
end
