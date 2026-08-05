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

ActiveRecord::Schema[8.0].define(version: 2026_08_05_125211) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "auth_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "expires_at", null: false
    t.datetime "last_used_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token_digest", null: false
    t.index ["token_digest"], name: "index_auth_tokens_on_token_digest", unique: true
    t.index ["user_id", "expires_at"], name: "index_auth_tokens_on_user_id_and_expires_at"
    t.index ["user_id"], name: "index_auth_tokens_on_user_id"
  end

  create_table "block_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_block_categories_on_name", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "user_ftps", force: :cascade do |t|
    t.integer "ftp_value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "created_at"], name: "index_user_ftps_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_user_ftps_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "google", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "weight"
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

  create_table "workout_block_results", force: :cascade do |t|
    t.bigint "workout_result_id", null: false
    t.bigint "workout_block_id", null: false
    t.integer "average_power"
    t.integer "max_power"
    t.integer "average_cadence"
    t.integer "duration_seconds", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workout_block_id"], name: "index_workout_block_results_on_workout_block_id"
    t.index ["workout_result_id"], name: "index_workout_block_results_on_workout_result_id"
  end

  create_table "workout_blocks", force: :cascade do |t|
    t.integer "order_index"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "target_ftp_percentage", precision: 10, scale: 2
    t.bigint "workout_summary_id", null: false
    t.bigint "block_category_id", null: false
    t.index ["block_category_id"], name: "index_workout_blocks_on_block_category_id"
    t.index ["workout_summary_id"], name: "index_workout_blocks_on_workout_summary_id"
  end

  create_table "workout_results", force: :cascade do |t|
    t.bigint "workout_summary_id", null: false
    t.datetime "started_at", null: false
    t.datetime "finished_at"
    t.integer "total_duration_seconds", null: false
    t.integer "average_power"
    t.integer "max_power"
    t.integer "average_cadence"
    t.string "status", default: "completed", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_workout_results_on_user_id"
    t.index ["workout_summary_id"], name: "index_workout_results_on_workout_summary_id"
  end

  create_table "workout_summaries", force: :cascade do |t|
    t.string "name"
    t.integer "total_duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id", null: false
    t.index ["category_id"], name: "index_workout_summaries_on_category_id"
  end

  add_foreign_key "auth_tokens", "users"
  add_foreign_key "user_ftps", "users"
  add_foreign_key "workout_block_results", "workout_blocks"
  add_foreign_key "workout_block_results", "workout_results"
  add_foreign_key "workout_blocks", "block_categories"
  add_foreign_key "workout_blocks", "workout_summaries"
  add_foreign_key "workout_results", "users"
  add_foreign_key "workout_results", "workout_summaries"
  add_foreign_key "workout_summaries", "categories"
end
