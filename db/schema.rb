# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20180511135014) do

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id",   limit: 4
    t.string   "trackable_type", limit: 255
    t.integer  "owner_id",       limit: 4
    t.string   "owner_type",     limit: 255
    t.string   "key",            limit: 255
    t.text     "parameters",     limit: 65535
    t.integer  "recipient_id",   limit: 4
    t.string   "recipient_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "appearances", force: :cascade do |t|
    t.string   "image_background", limit: 255
    t.string   "theme_name",       limit: 255
    t.string   "setting_id",       limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size",    limit: 4
    t.integer  "assetable_id",      limit: 4
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width",             limit: 4
    t.integer  "height",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "brand",      limit: 255
    t.string   "url",        limit: 255
    t.string   "name",       limit: 255
    t.integer  "position",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "consultancies", force: :cascade do |t|
    t.string   "image",          limit: 255
    t.string   "name_es",        limit: 255
    t.string   "name_en",        limit: 255
    t.text     "description_es", limit: 65535
    t.text     "description_en", limit: 65535
    t.integer  "position",       limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string   "image",          limit: 255
    t.string   "name_es",        limit: 255
    t.text     "description_es", limit: 65535
    t.string   "name_en",        limit: 255
    t.text     "description_en", limit: 65535
    t.date     "date"
    t.integer  "quotas",         limit: 4
    t.float    "student_price",  limit: 24
    t.float    "public_price",   limit: 24
    t.integer  "position",       limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.float    "student_price2", limit: 24
    t.float    "public_price2",  limit: 24
    t.string   "permalink",      limit: 255
  end

  create_table "customizes", force: :cascade do |t|
    t.string   "file",       limit: 255
    t.boolean  "installed",  limit: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "galleries", force: :cascade do |t|
    t.string   "name_es",    limit: 255
    t.string   "name_en",    limit: 255
    t.integer  "position",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "google_adwords", force: :cascade do |t|
    t.string   "url",           limit: 255
    t.string   "campaign_name", limit: 255
    t.text     "description",   limit: 65535
    t.text     "script",        limit: 65535
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "google_analytics_settings", force: :cascade do |t|
    t.string   "ga_account_id",  limit: 255
    t.string   "ga_tracking_id", limit: 255
    t.boolean  "ga_status",      limit: 1
    t.integer  "setting_id",     limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "keppler_blog_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "permalink",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "keppler_blog_posts", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.text     "body",           limit: 65535
    t.integer  "user_id",        limit: 4
    t.integer  "category_id",    limit: 4
    t.integer  "subcategory_id", limit: 4
    t.string   "image",          limit: 255
    t.boolean  "public",         limit: 1
    t.boolean  "comments_open",  limit: 1
    t.boolean  "shared_enabled", limit: 1
    t.string   "permalink",      limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "keppler_blog_subcategories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "permalink",   limit: 255
    t.integer  "category_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "keppler_contact_us_message_settings", force: :cascade do |t|
    t.string   "mailer_to",   limit: 255
    t.string   "mailer_from", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "keppler_contact_us_messages", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "subject",    limit: 255
    t.string   "email",      limit: 255
    t.text     "content",    limit: 65535
    t.boolean  "read",       limit: 1
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "meta_tags", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.text     "meta_tags",   limit: 65535
    t.string   "url",         limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "navies", force: :cascade do |t|
    t.string   "image",          limit: 255
    t.string   "name_es",        limit: 255
    t.string   "name_en",        limit: 255
    t.text     "description_es", limit: 65535
    t.text     "description_en", limit: 65535
    t.integer  "position",       limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string   "photo",      limit: 255
    t.string   "name_es",    limit: 255
    t.string   "name_en",    limit: 255
    t.integer  "gallery_id", limit: 4
    t.boolean  "cover",      limit: 1
    t.integer  "position",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "image",            limit: 255
    t.string   "name_es",          limit: 255
    t.string   "name_en",          limit: 255
    t.text     "description_es",   limit: 65535
    t.text     "description_en",   limit: 65535
    t.integer  "productable_id",   limit: 4
    t.string   "productable_type", limit: 255
    t.integer  "position",         limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "products", ["productable_type", "productable_id"], name: "index_products_on_productable_type_and_productable_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "scaffolds", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "fields",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "scripts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "script",     limit: 65535
    t.string   "url",        limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.string   "phone",       limit: 255
    t.string   "mobile",      limit: 255
    t.string   "email",       limit: 255
    t.string   "logo",        limit: 255
    t.string   "favicon",     limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "smtp_settings", force: :cascade do |t|
    t.string   "server_address", limit: 255
    t.string   "port",           limit: 255
    t.string   "domain_name",    limit: 255
    t.string   "email",          limit: 255
    t.string   "password",       limit: 255
    t.integer  "setting_id",     limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "social_accounts", force: :cascade do |t|
    t.string   "facebook",    limit: 255
    t.string   "twitter",     limit: 255
    t.string   "instagram",   limit: 255
    t.string   "google_plus", limit: 255
    t.string   "tripadvisor", limit: 255
    t.string   "pinterest",   limit: 255
    t.string   "flickr",      limit: 255
    t.string   "behance",     limit: 255
    t.string   "dribbble",    limit: 255
    t.string   "tumblr",      limit: 255
    t.string   "github",      limit: 255
    t.string   "linkedin",    limit: 255
    t.string   "soundcloud",  limit: 255
    t.string   "youtube",     limit: 255
    t.string   "skype",       limit: 255
    t.string   "vimeo",       limit: 255
    t.integer  "setting_id",  limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "subscribers", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "dni",             limit: 4
    t.string   "email",           limit: 255
    t.string   "phone",           limit: 255
    t.string   "subscriber_type", limit: 255
    t.string   "college",         limit: 255
    t.string   "career",          limit: 255
    t.string   "semester",        limit: 255
    t.string   "attachment",      limit: 255
    t.string   "degree",          limit: 255
    t.string   "bill",            limit: 255
    t.integer  "position",        limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "course_id",       limit: 4
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "telematics", force: :cascade do |t|
    t.string   "image",          limit: 255
    t.string   "name_es",        limit: 255
    t.string   "name_en",        limit: 255
    t.text     "description_es", limit: 65535
    t.text     "description_en", limit: 65535
    t.integer  "position",       limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "test_modules", force: :cascade do |t|
    t.string   "photo",      limit: 255
    t.string   "name",       limit: 255
    t.string   "phone",      limit: 255
    t.boolean  "public",     limit: 1
    t.integer  "age",        limit: 4
    t.float    "weight",     limit: 24
    t.integer  "position",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "permalink",              limit: 255
    t.string   "username",               limit: 255
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.integer "role_id", limit: 4
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
