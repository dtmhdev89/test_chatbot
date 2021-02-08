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

ActiveRecord::Schema.define(version: 2021_02_08_133924) do

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
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
    t.index ["queue"], name: "index_delayed_jobs_on_queue"
  end

  create_table "movies", force: :cascade do |t|
    t.string "checksum"
    t.datetime "refresh_time", null: false
    t.text "m_data"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deleted_at"], name: "index_movies_on_deleted_at"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "schedule_type", null: false
    t.string "title_name", null: false
    t.integer "creator_id"
    t.text "noti_content", null: false
    t.text "scheduled_at"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id", "title_name"], name: "index_notifications_on_creator_id_and_title_name", unique: true
    t.index ["schedule_type"], name: "index_notifications_on_schedule_type"
  end

  create_table "users", force: :cascade do |t|
    t.integer "user_type", default: 0, null: false
    t.string "ref_email"
    t.integer "chat_type", default: 0, null: false
    t.string "ref_chat_account", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_type", "ref_email", "ref_chat_account"], name: "index_users_on_chat_type_and_ref_email_and_ref_chat_account", unique: true
    t.index ["user_type"], name: "index_users_on_user_type"
  end

  create_table "weathers", force: :cascade do |t|
    t.string "checksum"
    t.text "m_data"
    t.datetime "refresh_time", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deleted_at"], name: "index_weathers_on_deleted_at"
  end

end
