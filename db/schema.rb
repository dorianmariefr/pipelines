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

ActiveRecord::Schema[7.0].define(version: 2023_01_11_182103) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "cron"
    t.index %w[priority run_at], name: "delayed_jobs_priority"
  end

  create_table "destinations", force: :cascade do |t|
    t.bigint "pipeline_id", null: false
    t.string "kind", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "destinable_type", null: false
    t.bigint "destinable_id", null: false
    t.index %w[destinable_type destinable_id],
            name: "index_destinations_on_destinable"
    t.index ["pipeline_id"], name: "index_destinations_on_pipeline_id"
  end

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

  create_table "items", force: :cascade do |t|
    t.bigint "source_id", null: false
    t.string "external_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "extras", default: {}, null: false
    t.index %w[source_id external_id],
            name: "index_items_on_source_id_and_external_id",
            unique: true
    t.index ["source_id"], name: "index_items_on_source_id"
  end

  create_table "parameters", force: :cascade do |t|
    t.string "parameterizable_type", null: false
    t.bigint "parameterizable_id", null: false
    t.string "key", null: false
    t.string "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index %w[parameterizable_type parameterizable_id],
            name: "index_parameters_on_parameterable"
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

  create_table "pipelines", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", default: "", null: false
    t.boolean "published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_pipelines_on_slug", unique: true
    t.index ["user_id"], name: "index_pipelines_on_user_id"
  end

  create_table "sources", force: :cascade do |t|
    t.bigint "pipeline_id", null: false
    t.string "kind", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "filter", default: "", null: false
    t.index ["pipeline_id"], name: "index_sources_on_pipeline_id"
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
    t.string "time_zone", default: "UTC", null: false
    t.string "locale", default: "en", null: false
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

  add_foreign_key "destinations", "pipelines"
  add_foreign_key "emails", "users"
  add_foreign_key "items", "sources"
  add_foreign_key "phone_numbers", "users"
  add_foreign_key "pipelines", "users"
  add_foreign_key "sources", "pipelines"
  add_foreign_key "users", "emails", column: "primary_email_id"
  add_foreign_key "users", "phone_numbers", column: "primary_phone_number_id"
end
