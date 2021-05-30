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

ActiveRecord::Schema.define(version: 2021_05_29_123607) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.string "slug"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_articles_on_slug", unique: true
  end

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.string "slug"
    t.integer "position"
    t.text "short_description"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_authors_on_slug", unique: true
  end

  create_table "authors_books", force: :cascade do |t|
    t.integer "author_id"
    t.integer "book_id"
    t.integer "position"
    t.index ["author_id"], name: "index_authors_books_on_author_id"
    t.index ["book_id"], name: "index_authors_books_on_book_id"
  end

  create_table "book_extra_images", force: :cascade do |t|
    t.integer "book_id"
    t.string "image"
    t.integer "position"
    t.string "title"
    t.index ["book_id"], name: "index_book_extra_images_on_book_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "image"
    t.text "description"
    t.integer "pages_amount"
    t.decimal "main_price", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "available_variants"
    t.string "ebook_file"
    t.string "audio_file"
    t.string "slug"
    t.boolean "is_available", default: false
    t.string "fragment_file"
    t.text "cover_designer"
    t.text "translator"
    t.text "age_recommendations"
    t.string "weight"
    t.string "dimensions"
    t.string "isbn"
    t.text "authors_within_anthology"
    t.boolean "is_top", default: false
    t.datetime "published_at", default: "2013-01-01 00:00:00"
    t.index ["slug"], name: "index_books_on_slug", unique: true
  end

  create_table "books_series", force: :cascade do |t|
    t.integer "book_id"
    t.integer "series_id"
    t.index ["book_id"], name: "index_books_series_on_book_id"
    t.index ["series_id"], name: "index_books_series_on_series_id"
  end

  create_table "bookstores", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "image"
    t.text "location_name"
    t.decimal "location_lat", precision: 15, scale: 10
    t.decimal "location_lng", precision: 15, scale: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.integer "assetable_id"
    t.string "assetable_type", limit: 30
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "book_id"
    t.integer "order_id"
    t.string "variant"
    t.decimal "price", precision: 8, scale: 2
    t.integer "quantity"
    t.index ["book_id"], name: "index_line_items_on_book_id"
    t.index ["order_id"], name: "index_line_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "customer_id"
    t.string "customer_type"
    t.string "status"
    t.text "failure_comment"
    t.decimal "total", precision: 8, scale: 2
    t.string "payment_method"
    t.string "phone"
    t.string "email"
    t.string "full_name"
    t.string "shipping_method"
    t.string "shipping_service"
    t.string "shipping_service_details"
    t.text "comment"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city"
    t.string "street"
    t.string "password_digest"
    t.boolean "form_submission_started", default: false
    t.datetime "submitted_at"
    t.string "raw_promo_code"
    t.integer "promo_code_id"
    t.decimal "total_no_promo", precision: 8, scale: 2
    t.decimal "balance", precision: 8, scale: 2, default: "0.0"
    t.index ["promo_code_id"], name: "index_orders_on_promo_code_id"
  end

  create_table "payment_failure_reasons", force: :cascade do |t|
    t.bigint "payment_id"
    t.string "reason", limit: 1000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "order_id"
    t.decimal "amount", precision: 8, scale: 2
    t.string "status", limit: 30, default: "initiated"
    t.string "payment_type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id", "status"], name: "index_payments_on_order_id_and_status"
  end

  create_table "promo_codes", force: :cascade do |t|
    t.string "code"
    t.datetime "expires_at"
    t.integer "limit"
    t.integer "orders_count"
    t.integer "discount_percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_promo_codes_on_code", unique: true
  end

  create_table "series", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.string "description", limit: 10000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_series_on_slug", unique: true
  end

  create_table "settings", force: :cascade do |t|
    t.string "phone"
    t.string "email"
    t.string "facebook"
    t.string "twitter"
    t.string "instagram"
    t.string "home_hero_title"
    t.text "home_hero_details"
    t.string "home_hero_image"
    t.text "team_hero_details"
    t.text "home_hero_link"
    t.integer "free_shipping_price_after"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "team_members", force: :cascade do |t|
    t.string "name"
    t.string "role"
    t.string "image"
    t.string "motto"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "temporary_users", force: :cascade do |t|
    t.string "uuid"
    t.datetime "last_active_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tokens_for_digital_books", force: :cascade do |t|
    t.string "code"
    t.string "variant"
    t.integer "order_id"
    t.integer "book_id"
    t.integer "downloads_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_used", default: false
    t.index ["book_id"], name: "index_tokens_for_digital_books_on_book_id"
    t.index ["code"], name: "index_tokens_for_digital_books_on_code"
    t.index ["order_id"], name: "index_tokens_for_digital_books_on_order_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "name"
    t.string "oauth_provider"
    t.string "oauth_uid"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_favorite_books", force: :cascade do |t|
    t.integer "user_id"
    t.integer "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_favorited", default: true
    t.index ["book_id"], name: "index_users_favorite_books_on_book_id"
    t.index ["user_id"], name: "index_users_favorite_books_on_user_id"
  end

end
