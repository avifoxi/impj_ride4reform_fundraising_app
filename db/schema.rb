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

ActiveRecord::Schema.define(version: 20150314200413) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "donations", force: true do |t|
    t.boolean  "anonymous_to_public",        default: false
    t.text     "note_to_rider"
    t.integer  "rider_year_registration_id"
    t.integer  "receipt_id"
    t.integer  "ride_year_id"
    t.integer  "user_id"
    t.integer  "amount"
    t.boolean  "fee_is_processed",           default: false
    t.boolean  "is_organizational",          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "donations", ["receipt_id"], name: "index_donations_on_receipt_id", using: :btree
  add_index "donations", ["ride_year_id"], name: "index_donations_on_ride_year_id", using: :btree
  add_index "donations", ["rider_year_registration_id"], name: "index_donations_on_rider_year_registration_id", using: :btree

  create_table "mailing_addresses", force: true do |t|
    t.integer  "user_id"
    t.string   "line_1"
    t.string   "line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "users_primary", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mailing_addresses", ["user_id"], name: "index_mailing_addresses_on_user_id", using: :btree

  create_table "persistent_rider_profiles", force: true do |t|
    t.integer  "user_id"
    t.text     "bio"
    t.date     "birthdate"
    t.string   "primary_phone"
    t.string   "secondary_phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "receipts", force: true do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.string   "paypal_id"
    t.text     "full_paypal_hash"
    t.boolean  "by_check",         default: false
    t.integer  "check_num"
    t.string   "bank"
    t.date     "check_dated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "receipts", ["user_id"], name: "index_receipts_on_user_id", using: :btree

  create_table "ride_years", force: true do |t|
    t.integer  "registration_fee"
    t.integer  "registration_fee_early"
    t.integer  "min_fundraising_goal"
    t.integer  "year"
    t.date     "ride_start_date"
    t.date     "ride_end_date"
    t.date     "early_bird_cutoff"
    t.integer  "current",                default: 0
    t.boolean  "disable_public_site",    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rider_year_registrations", force: true do |t|
    t.integer  "ride_year_id"
    t.integer  "user_id"
    t.integer  "goal"
    t.boolean  "agree_to_terms"
    t.string   "ride_option"
    t.integer  "registration_payment_receipt_id"
    t.boolean  "active_for_fundraising",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rider_year_registrations", ["ride_year_id"], name: "index_rider_year_registrations_on_ride_year_id", using: :btree
  add_index "rider_year_registrations", ["user_id"], name: "index_rider_year_registrations_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
