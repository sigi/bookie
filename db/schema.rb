# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100609224553) do

  create_table "bets", :force => true do |t|
    t.integer  "result1",    :limit => 4, :default => -1, :null => false
    t.integer  "result2",    :limit => 4, :default => -1, :null => false
    t.integer  "user_id",                                 :null => false
    t.integer  "match_id",                                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bets", ["match_id"], :name => "match_id"
  add_index "bets", ["user_id"], :name => "user_id"

  create_table "comments", :force => true do |t|
    t.string   "text",       :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "divisions", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "matches", :force => true do |t|
    t.integer  "result1",     :limit => 4, :default => -1, :null => false
    t.integer  "result2",     :limit => 4, :default => -1, :null => false
    t.datetime "date",                                     :null => false
    t.text     "info"
    t.integer  "team1_id",                                 :null => false
    t.integer  "team2_id",                                 :null => false
    t.integer  "division_id",                              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches", ["division_id"], :name => "division_id"
  add_index "matches", ["team1_id"], :name => "team1_id"
  add_index "matches", ["team2_id"], :name => "team2_id"

  create_table "specialbets", :force => true do |t|
    t.integer  "special1_id", :default => 1, :null => false
    t.string   "special2"
    t.integer  "special3_id", :default => 1, :null => false
    t.integer  "special4_id", :default => 1, :null => false
    t.integer  "special5_id", :default => 1, :null => false
    t.integer  "special6_id", :default => 1, :null => false
    t.string   "special7"
    t.integer  "user_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "real_name",                             :null => false
    t.string   "email",                                 :null => false
    t.string   "crypted_password",                      :null => false
    t.string   "password_salt",                         :null => false
    t.string   "persistence_token",                     :null => false
    t.string   "perishable_token",                      :null => false
    t.integer  "login_count",        :default => 0,     :null => false
    t.integer  "failed_login_count", :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "locked",             :default => false, :null => false
    t.boolean  "admin",              :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
