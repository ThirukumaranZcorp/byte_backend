# app/controllers/api/v1/notifications_controller.rb
class Api::V1::AdminNotificationsController < ApplicationController
  def index
    render json: AdminNotification.where(read: false).order(created_at: :desc)
  end

  def mark_as_read
    notification = AdminNotification.find(params[:id])
    notification.update(read: true)
    render json: { message: "Notification marked as read" }
  end

  def upcoming_payouts
    user = User.find(params[:id])
    if user.update(payout_day: params[:payout_day])
      render json: { message: "Payout day updated successfully", payout_day: user.payout_day }
    else
      render json: { error: "Failed to update payout day" }, status: :unprocessable_entity
    end
  end

  

end
