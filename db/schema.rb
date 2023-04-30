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

ActiveRecord::Schema[7.0].define(version: 2023_04_30_175854) do
  create_table "dishes", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dishes_foods", force: :cascade do |t|
    t.integer "dish_id", null: false
    t.integer "food_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dish_id"], name: "index_dishes_foods_on_dish_id"
    t.index ["food_id"], name: "index_dishes_foods_on_food_id"
  end

  create_table "foods", force: :cascade do |t|
    t.string "name"
    t.integer "deadline"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "foods_shops", force: :cascade do |t|
    t.integer "food_id", null: false
    t.integer "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_foods_shops_on_food_id"
    t.index ["shop_id"], name: "index_foods_shops_on_shop_id"
  end

  create_table "recipe_urls", force: :cascade do |t|
    t.string "url"
    t.integer "dish_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dish_id"], name: "index_recipe_urls_on_dish_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "dishes_foods", "dishes"
  add_foreign_key "dishes_foods", "foods"
  add_foreign_key "foods_shops", "foods"
  add_foreign_key "foods_shops", "shops"
  add_foreign_key "recipe_urls", "dishes"
end
