class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.string :month
      t.string :confirmation_number
      t.datetime :transaction_date
      t.string :from_account
      t.string :to_account
      t.string :bank
      t.decimal :amount, precision: 15, scale: 2
      t.decimal :fee, precision: 15, scale: 2
      t.decimal :total, precision: 15, scale: 2
      t.string :service
      t.string :ref_number
      t.string :notes
      t.string :status
      t.string :remarks
      t.string :currency
      t.belongs_to :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
