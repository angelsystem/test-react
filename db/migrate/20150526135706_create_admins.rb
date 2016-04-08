class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :name
      t.string :email, null: false, default: ""
      t.string :password_digest

      t.timestamps null: false
    end

    add_index :admins, :email, unique: true
  end
end
