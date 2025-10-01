class Api::V1::PaymentDetailsController < ApplicationController
  def create
    payment_detail = PaymentDetail.new(payment_detail_params)
    if payment_detail.save
      render json: payment_detail, status: :created
    else
      render json: { errors: payment_detail.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    render json: PaymentDetail.all
  end

  private

  def payment_detail_params
    params.require(:payment_detail).permit(:bank_name, :account_name, :account_number, :swift_code)
  end
end
