# frozen_string_literal: true

module Api
  module V1
    # Registration Controller
    class RegistrationsController < Api::V1::BaseController
      respond_to :json
      skip_before_action :authenticate_user!, only: [:create]

      def create
        @user = User.new(sign_up_params)
        if @user.save && @user.errors.empty?
          data = { user: @user, token: token_for_user(@user) }
        else
          message = "user creation failed: #{@user.errors.full_messages.join(', ')}"
        end
        render json: { data: data, message: message }
      end

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end
