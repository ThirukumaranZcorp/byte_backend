class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :body
      t.references :user, null: false, foreign_key: true
      t.boolean :read
      t.boolean :admin

      t.timestamps
    end
  end
end
