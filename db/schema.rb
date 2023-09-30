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

ActiveRecord::Schema[7.0].define(version: 2023_09_15_185311) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "entities", force: :cascade do |t|
    t.string "type", null: false
    t.string "name", null: false
    t.citext "slug", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_entities_on_slug"
    t.index ["type", "slug"], name: "index_entities_on_type_and_slug", unique: true
    t.index ["user_id"], name: "index_entities_on_user_id"
  end

  create_table "entity_users", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "user_id", null: false
    t.integer "role", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_entity_users_on_entity_id"
    t.index ["entity_id"], name: "unique_owner_role_in_entity", unique: true, where: "(role = 0)"
    t.index ["user_id", "entity_id"], name: "index_entity_users_on_user_id_and_entity_id", unique: true
    t.index ["user_id"], name: "index_entity_users_on_user_id"
  end

  create_table "job_descriptions", force: :cascade do |t|
    t.bigint "organisation_id", null: false
    t.string "title", null: false
    t.string "job_role", null: false
    t.string "experience_level", default: [], null: false, array: true
    t.string "job_type", null: false
    t.text "description", null: false
    t.integer "minimum_annual_salary", null: false
    t.integer "maximum_annual_salary", null: false
    t.boolean "offers_equity", default: false, null: false
    t.string "technologies", default: [], null: false, array: true
    t.boolean "visa_sponsorship", default: false, null: false
    t.boolean "relocation_assistance", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_job_descriptions_on_organisation_id"
  end

  create_table "organisations", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.string "name", null: false
    t.citext "slug", null: false
    t.text "headline", null: false
    t.text "description"
    t.string "website_url"
    t.string "industry", default: [], null: false, array: true
    t.string "company_size", null: false
    t.string "company_type", null: false
    t.string "joel_test", default: [], null: false, array: true
    t.string "country", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_organisations_on_entity_id"
    t.index ["slug"], name: "index_organisations_on_slug"
  end

  create_table "user_login_change_keys", force: :cascade do |t|
    t.string "key", null: false
    t.string "login", null: false
    t.datetime "deadline", null: false
  end

  create_table "user_password_reset_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "user_remember_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
  end

  create_table "user_verification_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "requested_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "status", limit: 2, default: 1, null: false
    t.citext "email", null: false
    t.string "password_hash"
    t.index ["email"], name: "index_users_on_email", unique: true, where: "(status = ANY (ARRAY[1, 2]))"
  end

  add_foreign_key "entities", "users"
  add_foreign_key "entity_users", "entities"
  add_foreign_key "entity_users", "users"
  add_foreign_key "job_descriptions", "organisations"
  add_foreign_key "organisations", "entities"
  add_foreign_key "user_login_change_keys", "users", column: "id"
  add_foreign_key "user_password_reset_keys", "users", column: "id"
  add_foreign_key "user_remember_keys", "users", column: "id"
  add_foreign_key "user_verification_keys", "users", column: "id"
end
