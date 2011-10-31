# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111030194316) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.integer  "callback"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "can_helps", :force => true do |t|
    t.integer  "missing_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "can_helps_places", :force => true do |t|
    t.integer  "place_id"
    t.integer  "can_help_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "can_helps_places", ["can_help_id"], :name => "index_can_helps_places_on_can_help_id"
  add_index "can_helps_places", ["place_id"], :name => "index_can_helps_places_on_place_id"

  create_table "discussions", :force => true do |t|
    t.text     "comment"
    t.integer  "discussion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "missing_id"
    t.integer  "user_id"
  end

  add_index "discussions", ["discussion_id"], :name => "index_discussions_on_discussion_id"

  create_table "familiars", :force => true do |t|
    t.string   "name"
    t.string   "relations"
    t.string   "relations_quality"
    t.text     "relations_tense_description"
    t.text     "description"
    t.boolean  "seen_last_day"
    t.integer  "missing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "familiars", ["missing_id"], :name => "index_familiars_on_missing_id"

  create_table "impressions", :force => true do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "session_hash"
    t.string   "ip_address"
    t.string   "message"
    t.string   "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], :name => "controlleraction_ip_index"
  add_index "impressions", ["controller_name", "action_name", "request_hash"], :name => "controlleraction_request_index"
  add_index "impressions", ["controller_name", "action_name", "session_hash"], :name => "controlleraction_session_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], :name => "poly_ip_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], :name => "poly_request_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], :name => "poly_session_index"
  add_index "impressions", ["user_id"], :name => "index_impressions_on_user_id"

  create_table "messages", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "destination_user_id"
    t.integer  "message_id"
    t.text     "text"
  end

  add_index "messages", ["account_id"], :name => "index_messages_on_account_id"

  create_table "missings", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "gender"
    t.date     "birthday"
    t.text     "characteristics"
    t.integer  "private"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.date     "date"
  end

  create_table "photos", :force => true do |t|
    t.string   "image_name"
    t.integer  "missing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
  end

  add_index "photos", ["missing_id"], :name => "index_photos_on_missing_id"

  create_table "places", :force => true do |t|
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.string   "name"
    t.text     "description"
    t.integer  "missing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "missing"
    t.boolean  "is_missing"
  end

  add_index "places", ["missing_id"], :name => "index_places_on_missing_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "username",                     :null => false
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "phone"
    t.string   "callback"
    t.text     "coverage"
    t.text     "specialization"
    t.string   "image_name"
    t.integer  "role"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["last_logout_at", "last_activity_at"], :name => "index_users_on_last_logout_at_and_last_activity_at"
  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"

end
