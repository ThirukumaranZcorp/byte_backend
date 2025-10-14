class Transaction < ApplicationRecord
    belongs_to :user
    after_create :update_column_from_address

    private
        def update_column_from_address
            update_column(:from_account , 'BYTES EXCHANGE - PAYOUT')
        end
end
