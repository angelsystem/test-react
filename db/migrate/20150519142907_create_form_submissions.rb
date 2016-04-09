class CreateFormSubmissions < ActiveRecord::Migration
  def change
    create_table :form_submissions do |t|
      t.string :ip
      t.references :form, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
