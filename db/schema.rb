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

ActiveRecord::Schema[7.0].define(version: 2023_04_07_073211) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

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
    t.string "perturbation"
    t.bigint "source_id", null: false
    t.index ["date", "sens", "train", "perturbation"], name: "super_index_uniq", unique: true
    t.index ["source_id"], name: "index_disturbances_on_source_id"
  end

  create_table "services", force: :cascade do |t|
    t.date "date"
    t.string "numéro_service"
    t.string "horaire"
    t.string "destination"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "origine"
    t.string "mode"
    t.index ["date", "numéro_service"], name: "index_services_on_date_and_numéro_service", unique: true
  end

  create_table "sources", force: :cascade do |t|
    t.string "url"
    t.string "gare"
    t.string "sens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "collected_at"
  end

  create_table "sources_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "source_id", null: false
    t.index ["source_id"], name: "index_sources_users_on_source_id"
    t.index ["user_id"], name: "index_sources_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "nom"
    t.string "prénom"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "disturbances", "sources"

  create_view "gares", materialized: true, sql_definition: <<-SQL
      SELECT DISTINCT disturbances.origine
     FROM disturbances
    ORDER BY disturbances.origine;
  SQL
  create_view "perturbations", materialized: true, sql_definition: <<-SQL
      SELECT DISTINCT disturbances.perturbation
     FROM disturbances
    ORDER BY disturbances.perturbation;
  SQL
  create_view "trains", materialized: true, sql_definition: <<-SQL
      SELECT DISTINCT disturbances.train
     FROM disturbances
    ORDER BY disturbances.train;
  SQL
  create_view "infos", materialized: true, sql_definition: <<-SQL
      SELECT DISTINCT disturbances.information
     FROM disturbances
    WHERE (disturbances.information IS NOT NULL)
    ORDER BY disturbances.information;
  SQL
  create_view "cancelleds", materialized: true, sql_definition: <<-SQL
      SELECT DISTINCT disturbances.date,
      disturbances.train
     FROM disturbances
    WHERE ((disturbances.perturbation)::text = 'Supprimé'::text)
    ORDER BY disturbances.date DESC;
  SQL
end
