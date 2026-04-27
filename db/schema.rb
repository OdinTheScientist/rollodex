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

ActiveRecord::Schema[8.1].define(version: 2026_04_27_225408) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "aliases", force: :cascade do |t|
    t.bigint "aliasable_id", null: false
    t.string "aliasable_type", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["aliasable_type", "aliasable_id"], name: "index_aliases_on_aliasable"
    t.index ["aliasable_type", "aliasable_id"], name: "index_aliases_on_aliasable_type_and_aliasable_id"
    t.index ["name"], name: "index_aliases_on_name"
  end

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
    t.index ["name"], name: "index_positions_on_name_trgm", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "resource_techniques", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "resource_id", null: false
    t.bigint "technique_id", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id", "technique_id"], name: "index_resource_techniques_on_resource_and_technique", unique: true
    t.index ["resource_id"], name: "index_resource_techniques_on_resource_id"
    t.index ["technique_id"], name: "index_resource_techniques_on_technique_id"
  end

  create_table "resources", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "instructor_name"
    t.text "notes"
    t.integer "resource_type", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["resource_type"], name: "index_resources_on_resource_type"
    t.index ["title"], name: "index_resources_on_title_trgm", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "taggings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "tag_id", null: false
    t.bigint "technique_id", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["technique_id", "tag_id"], name: "index_taggings_on_technique_id_and_tag_id", unique: true
    t.index ["technique_id"], name: "index_taggings_on_technique_id"
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "technique_ending_position_variants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "position_variant_id", null: false
    t.bigint "technique_id", null: false
    t.datetime "updated_at", null: false
    t.index ["position_variant_id"], name: "idx_on_position_variant_id_83380ac600"
    t.index ["technique_id", "position_variant_id"], name: "index_ending_variants_on_technique_and_position_variant", unique: true
    t.index ["technique_id"], name: "index_technique_ending_position_variants_on_technique_id"
  end

  create_table "technique_starting_position_variants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "position_variant_id", null: false
    t.bigint "technique_id", null: false
    t.datetime "updated_at", null: false
    t.index ["position_variant_id"], name: "idx_on_position_variant_id_58074126e9"
    t.index ["technique_id", "position_variant_id"], name: "index_starting_variants_on_technique_and_position_variant", unique: true
    t.index ["technique_id"], name: "index_technique_starting_position_variants_on_technique_id"
  end

  create_table "techniques", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "gi_nogi", default: 0, null: false
    t.string "name", null: false
    t.integer "technique_type", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["gi_nogi"], name: "index_techniques_on_gi_nogi"
    t.index ["name"], name: "index_techniques_on_name", unique: true
    t.index ["name"], name: "index_techniques_on_name_trgm", opclass: :gin_trgm_ops, using: :gin
    t.index ["technique_type"], name: "index_techniques_on_technique_type"
  end

  add_foreign_key "position_variants", "positions"
  add_foreign_key "resource_techniques", "resources"
  add_foreign_key "resource_techniques", "techniques"
  add_foreign_key "taggings", "tags"
  add_foreign_key "taggings", "techniques"
  add_foreign_key "technique_ending_position_variants", "position_variants"
  add_foreign_key "technique_ending_position_variants", "techniques"
  add_foreign_key "technique_starting_position_variants", "position_variants"
  add_foreign_key "technique_starting_position_variants", "techniques"
end
