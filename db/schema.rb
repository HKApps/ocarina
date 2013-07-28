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

ActiveRecord::Schema.define(version: 20130727230434) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"

  create_table "authentications", force: true do |t|
    t.string   "provider",            null: false
    t.string   "uid",                 null: false
    t.integer  "user_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_token"
    t.string   "access_token_secret"
  end

  create_table "guests", force: true do |t|
    t.integer "user_id",     null: false
    t.integer "playlist_id", null: false
  end

  add_index "guests", ["user_id", "playlist_id"], name: "index_guests_on_user_id_and_playlist_id", using: :btree

  create_table "playlist_songs", force: true do |t|
    t.integer "playlist_id",             null: false
    t.integer "song_id",                 null: false
    t.integer "vote_count",  default: 0, null: false
    t.string  "path",                    null: false
    t.string  "media_url"
  end

  create_table "playlists", force: true do |t|
    t.string   "name",       null: false
    t.integer  "owner_id",   null: false
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "playlists", ["owner_id"], name: "index_playlists_on_owner_id", using: :btree

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

  create_table "votes", force: true do |t|
    t.integer "playlist_song_id",             null: false
    t.integer "user_id",                      null: false
    t.integer "decision",         default: 0, null: false
  end

  add_index "votes", ["playlist_song_id", "user_id"], name: "index_votes_on_playlist_song_id_and_user_id", unique: true, using: :btree

end
