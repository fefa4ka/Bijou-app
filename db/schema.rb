# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20120214113926) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.string   "namespace"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.string   "text"
    t.text     "human_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collections", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collections_questions", :id => false, :force => true do |t|
    t.integer "question_id"
    t.integer "collection_id"
  end

  create_table "discussions", :force => true do |t|
    t.text     "comment"
    t.integer  "discussion_id"
    t.integer  "missing_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "help_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "histories", :force => true do |t|
    t.integer  "missing_id"
    t.integer  "question_id"
    t.integer  "user_id"
    t.integer  "answer_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "histories", ["answer_id"], :name => "index_histories_on_answer_id"
  add_index "histories", ["missing_id"], :name => "index_histories_on_missing_id"
  add_index "histories", ["question_id"], :name => "index_histories_on_question_id"
  add_index "histories", ["user_id"], :name => "index_histories_on_user_id"

  create_table "impressions", :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=cp1251' do |t|
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
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "message_id"
    t.integer  "seen_the_missing_id"
    t.boolean  "sender_deleted",      :default => false
    t.boolean  "recipient_deleted",   :default => false
    t.string   "subject"
    t.text     "body"
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "missings", :force => true do |t|
    t.string   "name"
    t.boolean  "gender"
    t.date     "birthday"
    t.date     "date"
    t.boolean  "published"
    t.integer  "user_id"
    t.integer  "age"
    t.date     "last_seen"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "city"
    t.text     "history"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "missing_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["missing_id"], :name => "index_photos_on_missing_id"

  create_table "places", :force => true do |t|
    t.string   "address"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.string   "street"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questionnaires", :force => true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "questions", :force => true do |t|
    t.text     "text"
    t.string   "field_text"
    t.integer  "collection_id"
    t.integer  "questionnaire_id"
    t.integer  "answer_type"
    t.boolean  "other"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "related_questions", :force => true do |t|
    t.integer "related_question_id"
    t.integer "question_id"
    t.text    "answer"
  end

  create_table "searches", :force => true do |t|
    t.string   "keywords"
    t.boolean  "male"
    t.integer  "minimum_age"
    t.integer  "maximum_age"
    t.string   "last_seen"
    t.string   "region"
    t.integer  "region_type"
    t.boolean  "with_photo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "last_seen_start"
    t.date     "last_seen_end"
  end

  create_table "seen_the_missings", :force => true do |t|
    t.integer  "missing_id"
    t.integer  "user_id"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "user_answers", :id => false, :force => true do |t|
    t.integer  "id",                  :default => 0, :null => false
    t.integer  "missing_id"
    t.integer  "question_id"
    t.integer  "user_id"
    t.integer  "answer_id"
    t.text     "text"
    t.integer  "answer_type"
    t.integer  "questionnaire_id"
    t.text     "question_text"
    t.string   "question_field_text"
    t.text     "answer_human_text"
    t.string   "asnwer_text"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",                                 :default => "",    :null => false
    t.string   "phone"
    t.string   "callback"
    t.boolean  "admin",                                 :default => false
    t.boolean  "detective",                             :default => false
    t.boolean  "volunteer",                             :default => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "provider"
    t.boolean  "confirmed"
    t.boolean  "virtual"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
