# app/jobs/payout_notification_job.rb
class PayoutNotificationJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |user|
      if user.notify_admin?
        AdminNotification.create!(
          title: "Upcoming Payout",
          message: "Payout for ' #{user.name} ' is scheduled on #{user.payout_date_for_month.strftime('%d %B %Y')}."
        )
      end
    end
  end
end
