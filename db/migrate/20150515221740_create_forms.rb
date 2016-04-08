class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
      t.string :title, null: false
      t.text :description
      t.string :slug, null: false

      t.timestamps null: false
    end

    add_index :forms, :slug, unique: true
  end
end
