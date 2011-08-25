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

ActiveRecord::Schema.define(:version => 20110824212846) do

  create_table "familiars", :force => true do |t|
    t.integer  "missing_id"
    t.string   "name"
    t.integer  "relations"
    t.integer  "relations_quality"
    t.text     "relation_tense_description"
    t.text     "description"
    t.boolean  "seen_last_day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "missings", :force => true do |t|
    t.string   "man_name"
    t.text     "description"
    t.boolean  "man_gender"
    t.date     "man_birthday"
    t.text     "man_char_hash"
    t.string   "author_name"
    t.string   "author_phone"
    t.string   "author_email"
    t.integer  "author_callback_hash"
    t.integer  "missing_private_hash"
    t.string   "missing_password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.integer  "missing_id"
    t.string   "name"
    t.integer  "relations"
    t.integer  "relations_type"
    t.text     "relations_description"
    t.text     "description"
    t.boolean  "last_contact"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "missing_id"
    t.string   "image_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", :force => true do |t|
    t.integer  "missing_id"
    t.string   "address"
    t.float    "latitude"
    t.float    "longtitude"
    t.boolean  "gmaps"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
