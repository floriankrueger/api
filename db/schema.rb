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

ActiveRecord::Schema.define(version: 20150915133930) do

  create_table "cities", force: :cascade do |t|
    t.integer  "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "code"
  end

  add_index "cities", ["code"], name: "index_cities_on_code"
  add_index "cities", ["country_id"], name: "index_cities_on_country_id"

  create_table "conferences", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "continents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "code"
  end

  add_index "continents", ["code"], name: "index_continents_on_code"

  create_table "countries", force: :cascade do |t|
    t.integer  "continent_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "name"
    t.string   "code"
  end

  add_index "countries", ["code"], name: "index_countries_on_code"
  add_index "countries", ["continent_id"], name: "index_countries_on_continent_id"

  create_table "events", force: :cascade do |t|
    t.integer "conference_id"
    t.integer "city_id"
  end

  add_index "events", ["city_id"], name: "index_events_on_city_id"
  add_index "events", ["conference_id"], name: "index_events_on_conference_id"

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "name"
    t.string   "screen_name"
    t.string   "location"
    t.string   "description"
    t.string   "profile_image_url"
    t.string   "expanded_url"
    t.string   "domain"
    t.string   "external_id"
  end

end
