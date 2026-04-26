# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_25_234305) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "position_variants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.bigint "position_id", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["position_id", "name"], name: "index_position_variants_on_position_id_and_name", unique: true
    t.index ["position_id"], name: "index_position_variants_on_position_id"
  end

  create_table "positions", force: :cascade do |t|
    t.integer "category", default: 0, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_positions_on_category"
    t.index ["name"], name: "index_positions_on_name", unique: true
  end

  add_foreign_key "position_variants", "positions"
end
