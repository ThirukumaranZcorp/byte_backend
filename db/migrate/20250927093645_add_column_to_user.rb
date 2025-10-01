class AddColumnToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role , :integer 
    add_column  :users , :bank_name, :string
    add_column  :users , :account_name, :string
    add_column  :users , :account_number, :string
    add_column  :users , :swift_code, :string
  end
end
