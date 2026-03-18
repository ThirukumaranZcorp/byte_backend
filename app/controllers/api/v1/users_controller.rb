class Api::V1::UsersController < ApplicationController
  skip_before_action :authorize_request, only: [:destroy]

  def destroy
    user = User.find_by(id: params[:id])

    return render json: { error: "User not found" }, status: :not_found unless user

    if user.destroy
      render json: { message: "User deleted successfully" }, status: :ok
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
