require "csv"
class Api::V1::TransactionsController < ApplicationController
  before_action :authorize_request

    def show
    transaction = Transaction.where(user_id: params[:id])
    puts transaction.inspect
    render json: transaction
    end


#   def upload
#     file = params[:file]
#     return render json: { error: "No file uploaded" }, status: :bad_request unless file

#     CSV.foreach(file.path, headers: true) do |row|
#       current_user.transactions.create!(
#         month: row["Month"],
#         confirmation_number: row["Confirmation"],
#         transaction_date: row["Date & Time"],
#         from_account: row["From Account"],
#         to_account: row["To Account"],
#         bank: row["Bank"],
#         amount: row["Amount"],
#         fee: row["Fee"],
#         total: row["Total"],
#         service: row["Service"],
#         ref_number: row["Ref"],
#         notes: row["Notes"],
#         status: row["Status"],
#         remarks: row["Remarks"],
#         currency: row["Currency"],
#         user_id: params[:id]
#       )
#     end

#     render json: { message: "File uploaded successfully!" }
#   end
    def upload
    file = params[:file]
    return render json: { error: "No file uploaded" }, status: :bad_request unless file

    # Find the user passed in the URL (e.g., /upload_transactions/14)
    user = User.find_by(id: params[:id])
    return render json: { error: "User not found" }, status: :not_found unless user

    CSV.foreach(file.path, headers: true) do |row|
        user.transactions.create!(
        month: row["Month"],
        confirmation_number: row["Confirmation"],
        transaction_date: row["Date & Time"],
        from_account: row["From Account"],
        to_account: row["To Account"],
        bank: row["Bank"],
        amount: row["Amount"],
        fee: row["Fee"],
        total: row["Total"],
        service: row["Service"],
        ref_number: row["Ref"],
        notes: row["Notes"],
        status: row["Status"],
        remarks: row["Remarks"],
        currency: row["Currency"]
        )
    end

    render json: { message: "File uploaded successfully for user ##{user.id}!" }
    end

end


