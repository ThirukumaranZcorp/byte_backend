# app/controllers/api/user/profiles_controller.rb
class Api::V1::ProfilesController < ApplicationController
  before_action :authorize_request

  def show
    render json: current_user
  end

  def update
    if current_user.update(profile_params)
      render json: current_user
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.permit(:name,  :bank_name_or_crypto_type, :account_name, :account_number_or_wallet, :swift_or_protocol, :email, :phone_number)
  end
end
