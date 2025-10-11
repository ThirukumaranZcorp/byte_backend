class CreateAdminNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :admin_notifications do |t|
      t.string :title
      t.text :message
      t.boolean :read, default: false
      t.timestamps
    end
  end
end
