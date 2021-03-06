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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120809225323) do

  create_table "cohabitants", :force => true do |t|
    t.string   "department"
    t.string   "location"
    t.string   "contact_name"
    t.string   "contact_email"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "activated",     :default => true
  end

  create_table "cohabitants_notifications", :id => false, :force => true do |t|
    t.integer "cohabitant_id"
    t.integer "notification_id"
  end

  add_index "cohabitants_notifications", ["cohabitant_id", "notification_id"], :name => "c_n_index"
  add_index "cohabitants_notifications", ["notification_id", "cohabitant_id"], :name => "n_c_index"

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "notifications", ["user_id"], :name => "index_notifications_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "admin",           :default => false
    t.string   "password_digest"
    t.boolean  "wants_update",    :default => false
  end

end
