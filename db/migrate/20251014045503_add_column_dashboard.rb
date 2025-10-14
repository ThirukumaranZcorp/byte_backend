class AddColumnDashboard < ActiveRecord::Migration[8.0]
  def change
    add_column :dashbords, :min, :float
    add_column :dashbords, :max, :float
    add_column :dashbords, :mid, :float
    add_column :dashbords, :softer_month, :float
  end
end
