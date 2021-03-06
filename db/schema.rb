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

ActiveRecord::Schema.define(version: 2021_03_08_105234) do

  create_table "comments", force: :cascade do |t|
    t.string "review", null: false
    t.integer "user_id"
    t.integer "message_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id"], name: "index_comments_on_message_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "image_path", null: false
    t.integer "user_id"
    t.integer "message_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["image_path"], name: "index_images_on_image_path", unique: true
    t.index ["message_id"], name: "index_images_on_message_id"
    t.index ["user_id"], name: "index_images_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "username", null: false
    t.string "password_digest", null: false
    t.string "role", default: "editor", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "comments", "messages"
  add_foreign_key "comments", "users"
  add_foreign_key "images", "messages"
  add_foreign_key "images", "users"
  add_foreign_key "messages", "users"
end
