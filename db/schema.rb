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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151224234158) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "idea_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ideas", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "trip_id"
    t.integer  "idea_category_id"
    t.string   "title"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "location"
    t.text     "notes"
    t.string   "category"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "ideas", ["idea_category_id"], name: "index_ideas_on_idea_category_id", using: :btree
  add_index "ideas", ["trip_id"], name: "index_ideas_on_trip_id", using: :btree
  add_index "ideas", ["user_id"], name: "index_ideas_on_user_id", using: :btree

  create_table "relationships", force: :cascade do |t|
    t.string   "email"
    t.integer  "friend_id"
    t.integer  "group_trip_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "relationships", ["friend_id", "group_trip_id"], name: "index_relationships_on_friend_id_and_group_trip_id", unique: true, using: :btree
  add_index "relationships", ["friend_id"], name: "index_relationships_on_friend_id", using: :btree
  add_index "relationships", ["group_trip_id"], name: "index_relationships_on_group_trip_id", using: :btree

  create_table "travel_groups", force: :cascade do |t|
    t.integer "user_id"
    t.integer "trip_id"
  end

  add_index "travel_groups", ["trip_id"], name: "index_travel_groups_on_trip_id", using: :btree
  add_index "travel_groups", ["user_id"], name: "index_travel_groups_on_user_id", using: :btree

  create_table "trips", force: :cascade do |t|
    t.string   "name"
    t.string   "city"
    t.string   "state_or_province"
    t.string   "country"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "url"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "user_id"
  end

  add_index "trips", ["user_id"], name: "index_trips_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "slug"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "role"
  end

end
