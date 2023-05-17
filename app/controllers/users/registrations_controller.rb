class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  skip_before_action :verify_authenticity_token

  before_action :check_token_and_set_user_params, only: :create
  before_action :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:idaas_uid, :email])
  end

  private

  def respond_with(resource, _opts = {})
    register_success && return if resource.persisted?

    register_failed
  end

  def register_success
    render json: { message: 'Signed up sucessfully.' }
  end

  def register_failed
    render json: { message: "Something went wrong." }
  end

  def check_token_and_set_user_params
    decoded_token = CheckJwt.new(params[:token]).call
    return render json: { message: 'Invalid token' }, status: :unauthorized unless decoded_token

    # set user params for create
    params[:user] = {
      email: decoded_token.dig(0, "email"),
      idaas_uid: decoded_token.dig(0, "user_id"),
      password: Rails.application.credentials.devise[:common_password]
    }
  end
end
