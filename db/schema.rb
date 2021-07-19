# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_19_000335) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_enum :community_type, [
    "public",
    "private",
  ], force: :cascade

  create_table "communities", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.enum "access", null: false, enum_name: "community_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "tag", null: false
    t.index ["access"], name: "index_communities_on_access"
    t.index ["name"], name: "index_communities_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.text "username"
    t.text "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "password_digest"
    t.date "dob"
  end

end
