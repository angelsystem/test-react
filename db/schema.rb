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

ActiveRecord::Schema.define(version: 20150526195514) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "name"
    t.string   "email",           default: "", null: false
    t.string   "password_digest"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree

  create_table "survey_questions", force: :cascade do |t|
    t.string   "title"
    t.string   "help_text"
    t.string   "question_type"
    t.integer  "position"
    t.text     "data"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "survey_id"
  end

  add_index "survey_questions", ["survey_id"], name: "index_survey_questions_on_survey_id", using: :btree

  create_table "survey_responses", force: :cascade do |t|
    t.text     "answer"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "survey_submission_id"
    t.integer  "survey_question_id"
  end

  add_index "survey_responses", ["survey_question_id"], name: "index_survey_responses_on_survey_question_id", using: :btree
  add_index "survey_responses", ["survey_submission_id"], name: "index_survey_responses_on_survey_submission_id", using: :btree

  create_table "survey_submissions", force: :cascade do |t|
    t.string   "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "survey_id"
  end

  add_index "survey_submissions", ["survey_id"], name: "index_survey_submissions_on_survey_id", using: :btree

  create_table "surveys", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "slug",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "surveys", ["slug"], name: "index_surveys_on_slug", unique: true, using: :btree

  add_foreign_key "survey_questions", "surveys"
  add_foreign_key "survey_responses", "survey_questions"
  add_foreign_key "survey_responses", "survey_submissions"
  add_foreign_key "survey_submissions", "surveys"
end
