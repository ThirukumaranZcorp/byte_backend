class AddUserToDashboards < ActiveRecord::Migration[8.0]
  def change
    add_reference :dashbords, :user, null: false, foreign_key: true
  end
end
