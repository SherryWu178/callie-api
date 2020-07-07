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

ActiveRecord::Schema.define(version: 2020_06_18_084255) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "title"
    t.float "duration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "deadlines", force: :cascade do |t|
    t.string "title"
    t.datetime "datetime"
    t.bigint "activity_id"
    t.boolean "allDay"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_deadlines_on_activity_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean "completion"
    t.float "duration"
    t.bigint "activity_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_events_on_activity_id"
  end

  add_foreign_key "deadlines", "activities"
  add_foreign_key "events", "activities"
end
