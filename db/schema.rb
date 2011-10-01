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

ActiveRecord::Schema.define(:version => 20110929205755) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.integer  "callback"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "messages", :force => true do |t|
    t.text     "message"
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "destination_user_id"
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
  end

  create_table "photos", :force => true do |t|
    t.string   "image_name"
    t.integer  "missing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "callback"
    t.string   "phone"
  end

  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"

end
