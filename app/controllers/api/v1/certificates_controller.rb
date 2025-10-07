class Api::V1::CertificatesController < ApplicationController
    # before_action :authorize_request!, except: [:show, :test_pdf]
    # skip_before_action :authorize_request!, only: [:show, :test_pdf]
    skip_before_action :authorize_request, only: [:show, :test_pdf]
    # If your API controllers skip layout/rendering, make sure to enable views here.
    include ActionController::MimeResponds


    def show
        @participant = User.find(params[:id])

        respond_to do |format|
            format.html { render_certificate }
            format.pdf  { render_certificate }
            format.json { render json: { message: "Certificate available", participant_id: @participant.id } }
            format.any  { head :not_acceptable } # fallback for unknown formats
        end
    end


    def show_details
    user_details = User.where.not(role: 1)
    render json: user_details, status: :ok
    end


    # def user_details
    #     puts current_user.id.inspect
    #     puts "000000000000000--------------00000000000------"
    #     user_detail = User.find(current_user.id)
    #     puts user_detail.transactions.inspect
    #     puts "000000000000000--------------00000000000------"

    #     render json: user_detail, status: :ok
    # end

    def user_details
        user_detail = User.find(current_user.id)
        render json: user_detail.as_json(
            only: [:id, :full_name, :currency, :contribution_amount, :contribution_amount],  # pick user fields
            include: {
            transactions: {
                only: [:notes, :month, :confirmation_number, :status, :bank ,:total, :to_account ,:service ,:fee ,:currency] # pick transaction fields
            }
            }
        ), status: :ok
    end



    # def test_pdf
    #     pdf_html = <<-HTML
    #         <!DOCTYPE html>
    #         <html>
    #         <head>
    #             <meta charset="UTF-8">
    #             <title>Test PDF</title>
    #         </head>
    #         <body>
    #             <h1>Hello WickedPDF!</h1>
    #         </body>
    #         </html>
    #     HTML

    #     pdf = WickedPdf.new.pdf_from_string(pdf_html)

    #     send_data pdf,
    #                 filename: "test.pdf",
    #                 type: "application/pdf",
    #                 disposition: "inline"
    # end


    def test_pdf
    @participant = User.find(params[:id]) # Example dynamic object
    @issuance_date     = @participant.issuance_date || Date.today
    @distribution_date = @issuance_date + 1.day
    @start_date        = @distribution_date.next_month
    @end_date          = @start_date.next_year


    # Helper for formatted currency
    def format_currency(amount, currency = "GBP")
        symbol = currency == "GBP" ? "£" : "#{currency} "
        sprintf("#{symbol}%.2f", amount.to_f)
    end

    pdf_html = <<-HTML
        <!doctype html>
        <html>
        <head>
        <meta charset="utf-8" />
        <title>PROFIT SHARING CERTIFICATE</title>
        <style>
            @page { margin: 40px 50px; }
            body { font-family: "Times New Roman", Georgia, serif; font-size: 12pt; color: #111; line-height: 1.45; margin-left: 25px}
            .header { text-align: left; margin-bottom: 20px; }
            .issuer-contact { font-size: 10pt; color: #333; }
            .company { font-weight: 700; margin-top: 6px; }
            .title { text-align: center; margin: 20px 0; }
           .title h1 { font-size: 22pt; margin: 0; letter-spacing: 1px; }
            .title .sub { margin-top: 6px; font-size: 11pt; font-weight: 600; }
            .title .meta {
                text-align: left;   /* force these lines to left align */
                margin-left: 0;     /* ensures it starts at left edge */
                display: inline-block; /* keeps block from stretching full width */
            }
            .content { margin-top: 12px; }
            .section { margin-bottom: 14px; }
            .section h3 { margin: 8px 0; font-size: 13pt; text-decoration: none; }
            .row { display:flex; gap: 20px; }
            .col { flex: 1; }
            .signature { margin-top: 30px; display:flex; justify-content:space-between; align-items:center; }
            .sig-block { width: 48%; text-align: left;  }
            .block-right {width: 48%; text-align: left; margin: 0px;}
            .sig-line { margin-top: 24px; border-top: 1px solid #000; width: 80%; padding-top:6px; }
            .footer { margin-top: 40px; font-size: 9pt; color: #666; text-align: right; }
            .page-number { position: fixed; bottom: 20px; right: 50px; font-size: 9pt; color: #666; }
            .muted { color: #444; font-size: 11pt; }
            .bold { font-weight: 700; }
            .center { text-align: center; }
        </style>
        </head>
        <body>
        <div class="header" style="text-align:center; margin-bottom:20px;">
            <!-- Logo -->
            <div>
                <img src="file:///#{Rails.root.join('app/assets/images/zcrop3.png')}"
                    alt="Z Corp Logo"
                    style="height:80px; width:auto; margin-bottom:10px;" />                
            </div>
            <!-- Contact Info -->
            <div style="font-size:10pt; line-height:1.4;">
                <div>info@zcorp.space</div>
                <div>Unit 9G, One Corporate Place, Maple Grove, Antero Soriano Highway, General Trias,</div>
                <div>Cavite 4107, Philippines</div>
            </div>

            <!-- Divider Line -->
            <hr style="margin-top:15px; border:1px solid #000; width:100%;" />
        </div>



        <div class="title">
            <h1>PROFIT SHARING CERTIFICATE</h1>
        </div>
        <div class="section" >
            <div class="block-right">
                <p><strong>Issued by: </strong><span class="bold">Bytes Exchange – Z Corp.</span></p>
                <p><strong>Date of Issuance:</strong> 
                <span class="bold">#{@participant.issuance_date&.strftime("%d %B %Y") || Date.today.strftime("%d %B %Y")}</span>
                </p>
            </div>
        </div>


        <div class="content">
            <p>This is to certify that <strong>#{@participant.name || "—"}</strong> (“Participant”) has provided a capital contribution to <strong>Bytes Exchange – Z Corp.</strong> under the following terms and conditions:</p>

            <div class="section" >
            <h3>1. Contribution</h3>
            <p class="muted">
                The Participant has provided the sum of
                <strong>#{format_currency(@participant.contribution_amount, @participant.currency)}</strong>
                (#{@participant.currency || "GBP"}) (“Contribution”), which shall be utilized for trading and exchange-related activities under the management of the Company.
            </p>
            </div>

            <div class="section" >
            <h3><strong>2. Term</strong></h3>
            <p class="muted">
                This Certificate shall be valid from
                <strong>#{@start_date.strftime("%d %B %Y") || "—"}</strong>
                until
                <strong>#{@end_date.strftime("%d %B %Y") || "—"}</strong>
                (“Profit Term”).
            </p>
            </div>

            <div class="section"  >
            <h3>3. Profit Sharing and Payment Schedule</h3>
            <p class="muted">
                The Participant shall be entitled to receive a share of the trading profits generated during the Profit Term as described in the Investment Chart and Payment Schedule.
                Payment Schedule: Distributions shall be made on the <strong>4th day of each month</strong>, beginning <strong>#{@start_date.strftime("%d %B %Y") rescue "—"}</strong> and continuing until <strong>#{@end_date.strftime("%d %B %Y") || "—"}</strong>.
            </p>
            <ol >
            <li><strong>Profit Sharing:</strong> The Investment Chart reflects the Company’s assessment of profit share ranges and corresponding risk levels at a given point in time. These ranges and risk levels are subject to revision without prior notice in order to align with market conditions, strategic adjustments, and portfolio management considerations.</li>
            <li><strong>Payment Schedule:</strong> Distributions shall be processed within twenty-four (24) hours or the next business day following the receipt of funds. Thereafter, subsequent distributions shall follow a recurring one-month cycle, with profits made available to the Participant on a monthly basis for the duration of the Profit Term.</li>
            </ol>


            </div>

            <div class="section" >
            <h3>4. Trader’s Fee</h3>
            <p class="muted">A trader’s fee of <strong>three percent (3%) of trading proceeds</strong> shall be deducted prior to the calculation and distribution of profit shares.</p>
            </div>

            <div class="section" >
            <h3>5. Return of Contribution & Renewal</h3>
            <p class="muted">
                Within thirty (30) days after the conclusion of the <strong>Profit Term</strong>(a period of one year or twelve [12] months of equivalent participation), the Participant shall have the option to:
            </p>

            <ol>
                <li><strong>Withdraw</strong> the original Contribution in full; or</li>
                <li><strong>Reinvest</strong> the Contribution into a new profit-sharing term under mutually agreed conditions, subject to a <strong>renewal fee of five percent (5%)</strong> of the Contribution, which shall be deducted at the time of renewal.</li>
            </ol>
            <p class="muted" >
                Failure of the Participant to provide written instruction within the thirty (30) day period may, at the Company’s discretion, result in automatic renewal of the Contribution under the prevailing terms and conditions, inclusive of the applicable renewal fee.  
            </p>
            </div>

            <div class="section" >
            <h3>6. Banking / Cryptocurrency Details</h3>
            <p>Monthly distributions shall be remitted to the following account designated by the Participant:</p>
            <p><strong>Bank Name / Crypto Type:</strong> #{@participant.bank_name_or_crypto_type || "—"}</p>
            <p><strong>Account Name:</strong> #{@participant.account_name || "—"}</p>
            <p><strong>Account Number / Wallet address:</strong> #{@participant.account_number_or_wallet || "—"}</p>
            <p><strong>SWIFT Code / Blockchain Protocol:</strong> #{@participant.swift_or_protocol || "—"}</p>
            </div>


           <div class="section" style="margin-top:65px;">
            <h3>7. Currency Conversion & Settlement</h3>
            <p>All profit share payments and the return of Contribution shall be calculated in<strong> Pounds Sterling (GBP).</strong></p>
            
            <ul>
                <li><strong>Conversion Basis:</strong> The GBP-denominated amount due shall be converted into the receiving currency based on the prevailing <strong>GBP exchange rate published on OKX</strong> (https://www.okx.com/) at the time of transfer.</li>
                <li><strong>Stablecoin/USDT Settlement:</strong> If the Participant elects settlement in <strong>Tether (USDT) </strong>or another stablecoin, the Company shall remit the equivalent amount using the latest <strong>GBP/USDT rate on OKX </strong>at the time of transfer.</li>
                <li><strong>Responsibility for Fees:</strong>Any intermediary bank charges, blockchain network fees, or conversion-related deductions shall be borne by the Participant, unless otherwise agreed in writing.</li>
            </ul>
            </div>


            <div class="section">
            <h3>8. Smart Contract</h3>
            <p>This Certificate represents a private contractual arrangement between the Participant and the Company for profit-sharing purposes only. It is facilitated through a decentralized blockchain framework and constitutes a non-traditional financial instrument. It does not represent a public solicitation, investment security, or regulated financial product under applicable law.</p>
            </div>



            <div class="section">
            <h3>9. Risk Disclosure</h3>
            <p>The Participant acknowledges and accepts that all trading, exchange, and investment activities involve inherent risks, including but not limited to market volatility, liquidity fluctuations, and regulatory changes. While the Company endeavors to implement prudent strategies and operational safeguards to enhance accuracy and consistency,<strong> returns beyond the stated minimum guaranteed share cannot be assured.<strong></p>
            <p>By entering into this arrangement, the Participant confirms that they:</p>
            <ul>
                <li>Understand the nature of the risks involved in trading and exchange activities;</li>
                <li>Have reviewed the Investment Chart to gain a clear understanding of the allowable ranges and associated risk levels;</li>
                <li>Accept full responsibility for the decision to participate as an informed and knowledgeable investor.</li>
            </ul>
            <p>The Company shall not be held liable for losses or reduced returns arising from market conditions or factors beyond its reasonable control.</p>
            </div>


            <div class="section">
            <h3>Acknowledgement & Acceptance</h3>
            <p class="muted">By signing below, the Participant acknowledges and accepts the terms of this Profit Sharing Certificate.</p>

            <div class="signature">
                <div class="sig-block">
                    <div class="bold">For Participant</div>
                    <div>Name: <strong>#{@participant.name || "—"}</strong></div>
                    <div>Date: #{@participant.date_signed&.strftime("%d %B %Y") || "—"}</div>
                </div>
            </div>
            </div>

            <div class="footer">
            <div>BYTES EXCHANGE – RM08042025V1.0rev.</div>
            </div>
        </div>
        </body>
        </html>
    HTML

    pdf = WickedPdf.new.pdf_from_string(pdf_html)

    send_data pdf,
                filename: "certificate.pdf",
                type: "application/pdf",
                disposition: "attachment"
    end


    private

    def render_certificate
    render pdf: "certificate_#{@participant.certificate_id || @participant.id}",
            template: "certificates/show.html.erb",
            layout: "pdf",
            disposition: "attachment",
            page_size: "A4"
    end



end

