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

ActiveRecord::Schema.define(version: 20161022141238) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  end

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.string   "slug"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_articles_on_slug", unique: true, using: :btree
  end

  create_table "authors", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.string   "slug"
    t.integer  "position"
    t.text     "short_description"
    t.text     "description"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["slug"], name: "index_authors_on_slug", unique: true, using: :btree
  end

  create_table "authors_books", force: :cascade do |t|
    t.integer "author_id"
    t.integer "book_id"
    t.integer "position"
    t.index ["author_id"], name: "index_authors_books_on_author_id", using: :btree
    t.index ["book_id"], name: "index_authors_books_on_book_id", using: :btree
  end

  create_table "books", force: :cascade do |t|
    t.string   "title"
    t.string   "image"
    t.text     "description"
    t.integer  "pages_amount"
    t.string   "cover_type"
    t.decimal  "main_price",         precision: 8, scale: 2
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.json     "available_variants"
    t.string   "ebook_file"
    t.string   "audio_file"
  end

  create_table "bookstores", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image"
    t.text     "location_name"
    t.decimal  "location_lat",  precision: 15, scale: 10
    t.decimal  "location_lng",  precision: 15, scale: 10
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree
  end

  create_table "team_members", force: :cascade do |t|
    t.string   "name"
    t.string   "role"
    t.string   "image"
    t.string   "motto"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
