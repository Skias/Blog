class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|
      t.string :image_path, null: false, index: { unique: true }
      t.references :user, foreign_key: true
      t.references :message, foreign_key: true
      t.timestamps
    end
  end
end
