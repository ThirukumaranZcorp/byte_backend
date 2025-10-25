class Contribution < ApplicationRecord
  belongs_to :user
  has_one_attached :receipt
  enum :deposit_type, { usdt: "USDT", fiat: "FIAT" }
  enum :status, { pending: "pending", approved: "approved", rejected: "rejected" }

  validates :amount, presence: true
  validates :deposit_type, presence: true
end
