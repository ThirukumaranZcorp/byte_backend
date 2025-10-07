class Notification < ApplicationRecord
  # belongs_to :user
  belongs_to :user, optional: true
  # Scope for unread notifications
  scope :unread, -> { where(read: false) }
end
