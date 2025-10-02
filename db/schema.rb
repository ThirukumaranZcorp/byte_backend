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

ActiveRecord::Schema[8.0].define(version: 2025_09_27_093645) do
  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "phone_number"
    t.string "residential_address"
    t.decimal "contribution_amount", precision: 12, scale: 2
    t.string "currency", default: "GBP"
    t.date "issuance_date"
    t.date "start_date"
    t.date "end_date"
    t.string "method"
    t.string "bank_name_or_crypto_type"
    t.string "account_name"
    t.string "account_number_or_wallet"
    t.string "swift_or_protocol"
    t.boolean "terms_accepted", default: false
    t.boolean "risk_disclosure_accepted", default: false
    t.boolean "renewal_fee_accepted", default: false
    t.string "typed_name"
    t.date "date_signed"
    t.string "uploaded_signature_url"
    t.string "certificate_id"
    t.integer "role", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
