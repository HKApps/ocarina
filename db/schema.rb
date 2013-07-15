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

ActiveRecord::Schema.define(version: 20130715033126) do

  create_table "authentications", force: true do |t|
    t.string   "provider",            null: false
    t.string   "uid",                 null: false
    t.integer  "user_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_token"
    t.string   "access_token_secret"
  end

  create_table "parties", force: true do |t|
    t.string   "name",       null: false
    t.integer  "host_id",    null: false
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "parties", ["host_id"], name: "index_parties_on_host_id", using: :btree

  create_table "playlists", force: true do |t|
    t.integer  "party_id",               null: false
    t.integer  "song_id",                null: false
    t.integer  "up_votes",   default: 0
    t.integer  "down_votes", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "playlists", ["party_id", "song_id"], name: "index_playlists_on_party_id_and_song_id", using: :btree

  create_table "songs", force: true do |t|
    t.string   "name",       null: false
    t.string   "provider",   null: false
    t.string   "path",       null: false
    t.integer  "user_id",    null: false
    t.hstore   "properties"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",      null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
