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

ActiveRecord::Schema.define(version: 20200204122437) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "nps", force: :cascade do |t|
    t.integer "score"
    t.string "touchpoint"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "respondent_id"
    t.string "respondent_class"
    t.integer "object_id"
    t.string "object_class"
    t.index ["score", "respondent_id", "respondent_class", "object_id", "object_class", "touchpoint"], name: "index_nps_on_respondent_and_object", unique: true
  end

end
