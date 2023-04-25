# frozen_string_literal: true
require 'json_web_token'

class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: %i[create]
  
 respond_to :json

 def create
  user = User.find_by(email: params[:email]&.downcase)
  if user&.valid_password?(params[:password])
    render json: { message: 'You have successfully Logged in.', token: token_for_user(user) }, status: :ok
  else
    render json: {
      success: false,
      message: 'Wrong password!',
    }
  end
end

  private

  def respond_with(resource, _opts = {})
    render json: { message: 'You have successfully Logged in.' }, status: :ok
  end

  def respond_to_on_destroy
    current_user ? log_out_success : log_out_failure
  end

  def log_out_success
    render json: { message: "Logged out." }, status: :ok
  end

  def log_out_failure
    render json: { message: "Logged out failure."}, status: :unauthorized
  end

end
