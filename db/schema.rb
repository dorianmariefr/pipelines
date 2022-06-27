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

ActiveRecord::Schema[7.0].define(version: 2022_06_27_215132) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "emails", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "email", null: false
    t.boolean "verified", default: false, null: false
    t.string "verification_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "normalized_email"
    t.index ["email"], name: "index_emails_on_email", unique: true
    t.index ["user_id"], name: "index_emails_on_user_id"
    t.index ["verification_code"],
      name: "index_emails_on_verification_code",
      unique: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index %w[slug sluggable_type scope],
      name:
        "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope",
      unique: true
    t.index %w[slug sluggable_type],
      name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index %w[sluggable_type sluggable_id],
      name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "phone_numbers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "phone_number", null: false
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "normalized_phone_number"
    t.string "external_token"
    t.index ["phone_number"],
      name: "index_phone_numbers_on_phone_number",
      unique: true
    t.index ["user_id"], name: "index_phone_numbers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "password_digest", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "email_verified", default: false, null: false
    t.string "email_verification_token"
    t.string "slug"
    t.bigint "primary_email_id"
    t.bigint "primary_phone_number_id"
    t.index ["email_verification_token"],
      name: "index_users_on_email_verification_token",
      unique: true
    t.index ["primary_email_id"],
      name: "index_users_on_primary_email_id",
      unique: true
    t.index ["primary_phone_number_id"],
      name: "index_users_on_primary_phone_number_id",
      unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  add_foreign_key "emails", "users"
  add_foreign_key "phone_numbers", "users"
  add_foreign_key "users", "emails", column: "primary_email_id"
  add_foreign_key "users", "phone_numbers", column: "primary_phone_number_id"
end
