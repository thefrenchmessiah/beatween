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

ActiveRecord::Schema[7.1].define(version: 2023_12_07_112804) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chatrooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "generator_id", null: false
    t.bigint "buddy_id", null: false
    t.index ["buddy_id"], name: "index_chatrooms_on_buddy_id"
    t.index ["generator_id"], name: "index_chatrooms_on_generator_id"
  end

  create_table "follows", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "followed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "compatibility_score"
    t.bigint "generator_id", null: false
    t.bigint "buddy_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "playlist_id"
    t.index ["buddy_id"], name: "index_matches_on_buddy_id"
    t.index ["generator_id"], name: "index_matches_on_generator_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "content"
    t.bigint "chatroom_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chatroom_id"], name: "index_messages_on_chatroom_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.bigint "generator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "spotify_id"
    t.text "tracks"
    t.index ["generator_id"], name: "index_playlists_on_generator_id"
  end

  create_table "qr_codes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_qr_codes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "spotify_id"
    t.string "spotify_url"
    t.string "display_name"
    t.string "image_url"
    t.string "qr_code"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "spotify_auth"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "chatrooms", "users", column: "buddy_id"
  add_foreign_key "chatrooms", "users", column: "generator_id"
  add_foreign_key "follows", "users", column: "followed_id"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "matches", "users", column: "buddy_id"
  add_foreign_key "matches", "users", column: "generator_id"
  add_foreign_key "messages", "chatrooms", on_delete: :cascade
  add_foreign_key "messages", "users"
  add_foreign_key "playlists", "users", column: "generator_id"
  add_foreign_key "qr_codes", "users"
end
