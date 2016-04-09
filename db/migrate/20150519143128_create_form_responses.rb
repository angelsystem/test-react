class CreateFormResponses < ActiveRecord::Migration
  def change
    create_table :form_responses do |t|
      t.references :form_submission, index: true, foreign_key: true
      t.references :form_component, index: true, foreign_key: true
      t.text :answer

      t.timestamps null: false
    end
  end
end
