class CreateFormComponents < ActiveRecord::Migration
  def change
    create_table :form_components do |t|
      t.string :title
      t.string :help_text
      t.string :question_type
      t.integer :position
      t.text :data
      t.references :form, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
