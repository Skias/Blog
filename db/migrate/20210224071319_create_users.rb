class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null:false, unique: true
      t.string :username, null: false, unique: true
      t.string :password_digest, null: false
      t.string :role, null: false, default: "editor"
      t.timestamps
    end
  end
end
