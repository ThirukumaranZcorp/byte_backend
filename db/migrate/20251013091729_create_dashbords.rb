class CreateDashbords < ActiveRecord::Migration[8.0]
  def change
    create_table :dashbords do |t|
      t.float :fee, default: 3.0   # float type
      t.timestamps
    end
  end
end
