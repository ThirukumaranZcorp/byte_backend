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


    require "roo"

    def upload
        file = params[:file]
        return render json: { error: "No file uploaded" }, status: :bad_request unless file

        user = User.find_by(id: params[:id])
        return render json: { error: "User not found" }, status: :not_found unless user

        spreadsheet =
            case File.extname(file.original_filename)
            when ".csv"  then Roo::CSV.new(file.path)
            when ".xls"  then Roo::Excel.new(file.path)
            when ".xlsx" then Roo::Excelx.new(file.path)
            else
            return render json: { error: "Unsupported file format" }, status: :unprocessable_entity
            end

        header_row_index = 1 # change if your headers start lower
        header = spreadsheet.row(header_row_index).compact
        puts "🔹 Header Row: #{header.inspect}"

        ((header_row_index + 1)..spreadsheet.last_row).each do |i|
            row_data = spreadsheet.row(i)
            row = Hash[[header, row_data].transpose]
            next if row.values.all?(&:blank?)

            # puts "🔸 Row #{i}: #{row.inspect}"
            if (row["Date"].present? && row["Confirmation Number"] && row["Destination Account"])
                # puts "------------allowed--------Row #{row}"
                user.transactions.create!(
                    month: row["Date"],
                    confirmation_number: row["Confirmation Number"],
                    to_account: row["Destination Account"],
                    bank: row["Wallet Address/Bank Name"],
                    amount: row["Amount"],
                    fee: row["Transfer Fee"],
                    total: row["Total Amount"],
                    service: row["Transfer Medium"],
                    status: row["Status"],
                    month_count: row["Month"],
                    airdrop_amount: row["Airdrop Amount"],
                    profit_amount: row["Profit Amount"]
                )
            end
        end

        render json: { message: "File uploaded successfully for user ##{user.id}!" }
        rescue => e
        render json: { error: "Failed to process file: #{e.message}" }, status: :internal_server_error
    end



    # def upload
    # file = params[:file]
    # return render json: { error: "No file uploaded" }, status: :bad_request unless file

    # # Find the user passed in the URL (e.g., /upload_transactions/14)
    # user = User.find_by(id: params[:id])
    # return render json: { error: "User not found" }, status: :not_found unless user

    # CSV.foreach(file.path, headers: true) do |row|
    #     user.transactions.create!(
    #     month: row["Month"],
    #     confirmation_number: row["Confirmation"],
    #     transaction_date: row["Date & Time"],
    #     from_account: row["From Account"],
    #     to_account: row["To Account"],
    #     bank: row["Bank"],
    #     amount: row["Amount"],
    #     fee: row["Fee"],
    #     total: row["Total"],
    #     service: row["Service"],
    #     ref_number: row["Ref"],
    #     notes: row["Notes"],
    #     status: row["Status"],
    #     remarks: row["Remarks"],
    #     currency: row["Currency"]
    #     )
    # end

    # render json: { message: "File uploaded successfully for user ##{user.id}!" }
    # end

end


