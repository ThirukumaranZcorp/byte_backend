class CreateContributions < ActiveRecord::Migration[8.0]
  def change
    create_table :contributions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :deposit_type
      t.string :currency
      t.string :receipt
      t.string :status
      t.decimal :amount, precision: 10, scale: 2


      t.timestamps
    end
  end
end
