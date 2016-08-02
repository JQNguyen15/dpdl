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

ActiveRecord::Schema.define(version: 20160802031600) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "started",       default: false
    t.string   "winner"
    t.integer  "rad_votes",     default: 0
    t.integer  "dire_votes",    default: 0
    t.boolean  "aborted",       default: false
    t.integer  "host"
    t.integer  "players",       default: [],                 array: true
    t.integer  "radint",        default: [],                 array: true
    t.integer  "dire",          default: [],                 array: true
    t.float    "match_quality", default: 0.0
    t.string   "loser"
    t.boolean  "finished",      default: false
    t.integer  "draw_votes",    default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "uid"
    t.string   "nickname"
    t.string   "avatar_url"
    t.string   "profile_url"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.datetime "last_active_at"
    t.integer  "mmr",            default: 1000
    t.boolean  "in_game",        default: false
    t.boolean  "has_vote",       default: false
    t.boolean  "game_started",   default: false
    t.float    "skill",          default: 25.0
    t.float    "doubt",          default: 8.333333333333334
    t.integer  "wins",           default: 0
    t.integer  "losses",         default: 0
    t.integer  "draws",          default: 0
    t.string   "expectations"
    t.index ["uid"], name: "index_users_on_uid", unique: true, using: :btree
  end

end
