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

  def get_change_trader_fee
    dashboard = Dashbord.find(1)
    render json: dashboard
  end

  def change_the_fees
    fee = params[:fee].to_f
    puts "Fee param: #{fee}"

    dashboard = Dashbord.find(1) # or Dashbord if that's your actual model
    puts "----------------ddd------------"
    puts dashboard.inspect
    if dashboard.update(fee: fee)
      render json: { status: "success", fee: dashboard.fee }
    else
      render json: { status: "error", errors: dashboard.errors.full_messages }, status: :unprocessable_entity
    end
  end



  def change_trader_max
    max = params[:max]

    puts "Fee param: -------  #{max}"

    dashboard = Dashbord.find(1) # or Dashbord if that's your actual model
    puts "----------------ddd------------"
    puts dashboard.inspect
    if dashboard.update(max: max)
      render json: { status: "success", max: dashboard.max }
    else
      render json: { status: "error", errors: dashboard.errors.full_messages }, status: :unprocessable_entity
    end

  end

  def change_trader_min
    min = params[:min]

    puts "Fee param: ------------- #{min}"

    dashboard = Dashbord.find(1) # or Dashbord if that's your actual model
    puts "----------------ddd------------"
    puts dashboard.inspect
    if dashboard.update(min: min)
      render json: { status: "success", min: dashboard.min }
    else
      render json: { status: "error", errors: dashboard.errors.full_messages }, status: :unprocessable_entity
    end

  end


  private

  def profile_params
    params.permit(:name,  :bank_name_or_crypto_type, :account_name, :account_number_or_wallet, :swift_or_protocol, :email, :phone_number)
  end
end
