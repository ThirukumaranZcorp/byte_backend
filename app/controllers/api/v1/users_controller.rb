class Api::V1::UsersController < ApplicationController
  skip_before_action :authorize_request, only: [:destroy, :forgot_password, :change_password]

  def forgot_password
    user = User.find_by(email: params[:email])

    return render json: { error: "User not found" }, status: :not_found unless user

    user.send_reset_password_instructions

    render json: {
      message: "Password reset instructions sent successfully"
    }, status: :ok
  end


  def change_password
    user = User.find_by(id: params[:user_id])

    return render json: { error: "User not found" }, status: :not_found unless user

    unless user.valid_password?(params[:current_password])
      return render json: { error: "Current password is incorrect" }, status: :unprocessable_entity
    end

    if params[:password].blank? || params[:password_confirmation].blank?
      return render json: { error: "Password and password confirmation are required" }, status: :unprocessable_entity
    end

    unless params[:password] == params[:password_confirmation]
      return render json: { error: "Password confirmation doesn't match" }, status: :unprocessable_entity
    end

    if user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      render json: { message: "Password changed successfully" }, status: :ok
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

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
