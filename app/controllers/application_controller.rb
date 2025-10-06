class ApplicationController < ActionController::API
    # If you're building an API-only app, inherit from ActionController::API instead of ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?
  respond_to :json
  before_action :authorize_request
  before_action :set_default_format
    

  private

    def set_default_format
        request.format = :json
    end

    def authorize_request
        token = request.headers['Authorization']&.split(' ')&.last
        return render json: { error: 'Missing token' }, status: :unauthorized unless token

        begin
        decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256').first
        @current_user = User.find(decoded['sub'])
        rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
        end
    end


  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end
end
