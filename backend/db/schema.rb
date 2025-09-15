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

ActiveRecord::Schema[8.0].define(version: 2025_09_15_142244) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "user_ftps", force: :cascade do |t|
    t.integer "ftp_value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workout_blocks", force: :cascade do |t|
    t.integer "order_index"
    t.integer "duration"
    t.string "block_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "target_ftp_percentage", precision: 10, scale: 2
    t.bigint "workout_summary_id", null: false
    t.index ["workout_summary_id"], name: "index_workout_blocks_on_workout_summary_id"
  end

  create_table "workout_summaries", force: :cascade do |t|
    t.string "name"
    t.integer "total_duration"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "workout_blocks", "workout_summaries"
end
