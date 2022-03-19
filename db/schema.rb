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

ActiveRecord::Schema[7.0].define(version: 2022_03_19_182054) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "disturbances", force: :cascade do |t|
    t.string "date"
    t.string "train"
    t.string "départ"
    t.string "destination"
    t.string "voie"
    t.string "raison"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "origine"
    t.string "sens"
    t.string "arrivée"
    t.string "provenance"
    t.string "information"
    t.string "départ_prévu"
    t.string "départ_réel"
    t.string "arrivée_prévue"
    t.string "arrivée_réelle"
    t.jsonb "information_payload"
    t.integer "gare_id"
    t.index ["date", "sens", "train", "raison"], name: "super_index_uniq", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
