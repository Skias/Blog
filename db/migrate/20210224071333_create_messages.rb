class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
