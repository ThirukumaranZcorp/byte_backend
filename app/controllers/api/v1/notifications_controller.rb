# app/controllers/api/v1/notifications_controller.rb
class Api::V1::NotificationsController < ApplicationController
  before_action :authorize_request
  before_action :authorize_request, only: [:create]

  # GET /notifications
  def index
    # Show notifications for current user or global notifications
    @notifications = Notification.where(user: [current_user.id]).order(created_at: :desc)
    render json: @notifications
  end

  # POST /notifications (Admin only)
    def create
        if notification_params[:user_id].present?
            # Specific user notification
            @notification = Notification.new(notification_params.merge(admin: true))
            if @notification.save
            render json: @notification, status: :created
            else
            render json: @notification.errors, status: :unprocessable_entity
            end
        else
            # Broadcast notification (send to all users)
            User.find_each do |user|
            Notification.create!(
                title: notification_params[:title],
                body: notification_params[:body],
                user_id: user.id,
                admin: true
            )
            end
            render json: { message: "Notification sent to all users" }, status: :created
        end
    end


  # PATCH /notifications/:id/read
  def mark_as_read
    @notification = Notification.find(params[:id])
    @notification.update(read: true)
    render json: @notification
  end

  private

  def notification_params
    params.require(:notification).permit(:title, :body, :user_id)
  end


  def authorize_admin!
    render json: { error: "Forbidden" }, status: :forbidden unless current_user.admin?
  end
end
