# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :authorize_request, only: [:create]
  before_action :authorize_request, only: [:change_password]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  # respond_to :json

  # def create
  #   build_resource(sign_up_params)

  #   if resource.save
  #     render json: {
  #       message: "User registered successfully",
  #       user: resource
  #     }, status: :created
  #   else
  #     render json: {
  #       message: "Registration failed",
  #       errors: resource.errors.full_messages
  #     }, status: :unprocessable_entity
  #   end
  # end

 respond_to :json

  before_action :configure_sign_up_params, only: [:create]

  # POST /users
  # def create
  #   build_resource(sign_up_params)

  #   if resource.save
  #     token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
  #     render json: {
  #       message: "User registered successfully",
  #       user: resource,
  #       token: token
  #     }, status: :created
  #   else
  #     render json: {
  #       message: "Registration failed",
  #       errors: resource.errors.full_messages
  #     }, status: :unprocessable_entity
  #   end
  # end


  def create
    build_resource(sign_up_params)

    if resource.save
      # Create notification for admin when new user registers
      AdminNotification.create!(
        title: "New User Registered",
        message: "A new user '#{resource.name}' (#{resource.email}) has just registered on #{Time.current.strftime('%d %B %Y, %I:%M %p')}."
      )

      token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
      render json: {
        message: "User registered successfully",
        user: resource,
        token: token
      }, status: :created
    else
      render json: {
        message: "Registration failed",
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    render json: {
      message: "Registration failed",
      errors: ["Email already exists"]
    }, status: :unprocessable_entity
  end





  def change_password
    user = current_user
    # Use valid_password? instead of authenticate
    if user.valid_password?(params[:current_password])
      if params[:new_password].present?
        user.password = params[:new_password]
        if user.save
          render json: { message: "Password changed successfully" }, status: :ok
        else
          render json: { error: user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "New password cannot be blank" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Current password is incorrect" }, status: :unauthorized
    end
  end








  protected

  # Permit extra fields for sign up
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :name,          # your internal field
      :fullName,      # if frontend sends fullName
      :email,         # make sure email is permitted
      :phone_number,
      :residential_address,
      :contribution_amount,
      :currency,
      :issuance_date,
      :start_date,
      :end_date,
      :method,
      :bank_name_or_crypto_type,
      :account_name,
      :account_number_or_wallet,
      :swift_or_protocol,
      :terms_accepted,
      :risk_disclosure_accepted,
      :renewal_fee_accepted,
      :typed_name,
      :date_signed,
      :password, :password_confirmation
    ])
  end

  def sign_up_params
    params.require(:sign_up).permit(
      :fullName, :email, :password, :password_confirmation,
      :phone_number, :residential_address, :contribution_amount,
      :currency, :issuance_date, :start_date, :end_date,
      :method, :bank_name_or_crypto_type, :account_name,
      :account_number_or_wallet, :swift_or_protocol,
      :terms_accepted, :risk_disclosure_accepted,
      :renewal_fee_accepted, :typed_name, :date_signed
    ).tap do |whitelisted|
      whitelisted[:name] = whitelisted.delete(:fullName) if whitelisted[:fullName]
    end
  end


end
