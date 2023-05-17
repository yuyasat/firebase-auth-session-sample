class Users::SessionsController < Devise::SessionsController
  respond_to :json

  skip_before_action :verify_authenticity_token

  before_action :configure_permitted_parameters
  before_action :check_token_and_sign_in_user, only: [:create]

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:idaas_uid, :email])
  end

  private

  def respond_with(resource, _opts = {})
    render json: { message: 'You are logged in.' }, status: :ok
  end

  def respond_to_on_destroy
    log_out_success && return if current_user

    log_out_failure
  end

  def log_out_success
    render json: { message: "You are logged out." }, status: :ok
  end

  def log_out_failure
    render json: { message: "Hmm nothing happened."}, status: :unauthorized
  end

  def check_token_and_sign_in_user
    decoded_token = CheckJwt.new(params[:token]).call
    return render json: { message: 'Invalid token' }, status: :unauthorized unless decoded_token

    # find user and sign_in if user exists
    user = User.find_by(idaas_uid: decoded_token.dig(0, "user_id"))
    sign_in(user) if user
  end
end
