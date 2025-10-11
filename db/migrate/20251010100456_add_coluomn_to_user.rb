class AddColuomnToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :payout_day, :integer, default: 9
  end
end
