class AddCloumnToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :month_count, :integer
    add_column :transactions, :airdrop_amount, :decimal, precision: 15, scale: 2
    add_column :transactions, :profit_amount, :decimal, precision: 15, scale: 2
  end
end

