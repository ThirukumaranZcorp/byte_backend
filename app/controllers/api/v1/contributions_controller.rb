# class Api::V1::ContributionsController < ApplicationController
#   before_action :authorize_request

#   def index
#     render json: current_user.contributions.with_attached_receipt
#   end

#   def create
#     contribution = @current_user.contributions.new(contribution_params)
#     contribution.status ||= "pending"
    
#     if contribution.save
#       render json: {
#         message: "Contribution created successfully",
#         contribution: {
#           id: contribution.id,
#           deposit_type: contribution.deposit_type,
#           amount: contribution.amount,
#           currency: contribution.currency,
#           status: contribution.status,
#           receipt_url: contribution.receipt.attached? ? url_for(contribution.receipt) : nil,
#           created_at: contribution.created_at
#         }
#       }, status: :created
#     else
#       render json: { errors: contribution.errors.full_messages }, status: :unprocessable_entity
#     end
#   end

#   private

#   def contribution_params
#     params.permit(:deposit_type, :amount, :currency, :receipt)
#   end
# end

class Api::V1::ContributionsController < ApplicationController
  before_action :authorize_request
  before_action :set_contribution, only: [:approve, :reject]



   def index
      puts "-------------------------------------------old things ----------------------------------------------"

    contributions =
      if @current_user.role == 1
        Contribution.with_attached_receipt.includes(:user).all
      else
        @current_user.contributions.with_attached_receipt
      end

      puts "--------------------------------------------------------------------------------------"
      puts contributions.inspect

    render json: contributions.map { |c| contribution_response(c) }, status: :ok
  end





  def create
    contribution = @current_user.contributions.new(contribution_params)
    contribution.status ||= "pending"

    if contribution.save
      render json: {
        message: "Contribution created successfully",
        contribution: contribution_response(contribution)
      }, status: :created
    else
      render json: { errors: contribution.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ NEW: Approve contribution
  def approve
    if @current_user.role != 1
      return render json: { error: "Unauthorized" }, status: :forbidden
    end

    @contribution.update(status: "approved")
    user = User.find(@contribution.user_id)
    user.update(contribution_amount: params[:change_contribt])
    render json: { message: "Contribution approved successfully", contribution: contribution_response(@contribution) }
  end

  # ✅ NEW: Reject contribution
  def reject
    if @current_user.role != 1
      return render json: { error: "Unauthorized" }, status: :forbidden
    end

    @contribution.update(status: "rejected")
    render json: { message: "Contribution rejected", contribution: contribution_response(@contribution) }
  end

  private

  def set_contribution
    @contribution = Contribution.find(params[:id])
  end

  def contribution_params
    params.permit(:deposit_type, :amount, :currency, :receipt)
  end

  def contribution_response(contribution)
    {
      id: contribution.id,
      deposit_type: contribution.deposit_type,
      amount: contribution.amount,
      currency: contribution.currency,
      status: contribution.status,
      name: contribution.user.name,
      user_id: contribution.user_id,
      deposit_type: contribution.deposit_type,
      user_email: contribution.user.email, 
      current_contribt: contribution.user.contribution_amount,
      receipt_url: contribution.receipt.attached? ? url_for(contribution.receipt) : nil,
      created_at: contribution.created_at
    }
  end
end
