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

ActiveRecord::Schema.define(version: 2021_05_11_143830) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "academics", primary_key: "username", id: :string, force: :cascade do |t|
    t.string "department_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "academics_courses", force: :cascade do |t|
    t.string "username"
    t.bigint "module_id"
  end

  create_table "course_modules", force: :cascade do |t|
    t.integer "code"
    t.string "name"
    t.string "department_code"
    t.string "session_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "course_modules_students", force: :cascade do |t|
    t.integer "student_id"
    t.integer "module_id"
    t.index ["module_id", "student_id"], name: "index_course_modules_students_on_module_id_and_student_id"
    t.index ["student_id", "module_id"], name: "index_course_modules_students_on_student_id_and_module_id"
  end

  create_table "ddss_staff_members", id: false, force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

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
  end

  create_table "departments", id: false, force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dlos", id: false, force: :cascade do |t|
    t.string "username"
    t.string "department_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "lsps", id: false, force: :cascade do |t|
    t.integer "registration_number"
    t.string "disability_advisor_email"
    t.text "disability_info"
    t.text "access_evacuation_emergency_care"
    t.text "teaching"
    t.text "communication_ongoing_contact"
    t.text "exams_and_assessment"
    t.text "extenuating_circumstances"
    t.date "date_shared"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "disability_types"
    t.text "practical_course_elements"
    t.text "additional_recommendations"
  end

  create_table "module_sessions", primary_key: "code", id: :string, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string "message"
    t.string "link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "students", id: false, force: :cascade do |t|
    t.integer "registration_number"
    t.string "title"
    t.string "forename"
    t.string "surname"
    t.string "username"
    t.string "email"
    t.string "department_code"
    t.string "partial_programme_code"
    t.date "graduation_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "supervisor_roles", id: false, force: :cascade do |t|
    t.string "code"
    t.string "name"
  end

  create_table "supervisors", force: :cascade do |t|
    t.string "username"
    t.integer "student_id"
    t.string "role_code"
  end

  create_table "user_notifications", force: :cascade do |t|
    t.string "username"
    t.bigint "notification_id"
    t.boolean "read", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["notification_id", "username"], name: "index_user_notifications_on_notification_id_and_username", unique: true
    t.index ["username", "notification_id"], name: "index_user_notifications_on_username_and_notification_id", unique: true
  end

  create_table "users", id: false, force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uid"
    t.string "mail"
    t.string "ou"
    t.string "dn"
    t.string "sn"
    t.string "givenname"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email"
  end

end
