class AddMissingColumnsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :phone_number, :string
    add_column :users, :residential_address, :string
    add_column :users, :contribution_amount, :decimal, precision: 12, scale: 2
    add_column :users, :currency, :string, default: "GBP"
    add_column :users, :issuance_date, :date
    add_column :users, :start_date, :date
    add_column :users, :end_date, :date
    add_column :users, :method, :string
    add_column :users, :bank_name_or_crypto_type, :string
    add_column :users, :account_name, :string
    add_column :users, :account_number_or_wallet, :string
    add_column :users, :swift_or_protocol, :string
    add_column :users, :terms_accepted, :boolean, default: false
    add_column :users, :risk_disclosure_accepted, :boolean, default: false
    add_column :users, :renewal_fee_accepted, :boolean, default: false
    add_column :users, :typed_name, :string
    add_column :users, :date_signed, :date
    add_column :users, :uploaded_signature_url, :string
    add_column :users, :certificate_id, :string
    add_column :users, :role, :integer, default: 0
    add_column :users, :name, :string
  end
end
