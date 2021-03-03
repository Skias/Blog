class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :review, null: false
      t.references :user, foreign_key: true
      t.references :message, foreign_key: true
      t.timestamps
    end
  end
end
