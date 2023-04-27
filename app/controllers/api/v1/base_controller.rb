# frozen_string_literal: true

module Api
  module V1
    # base_controller
    class BaseController < ApplicationController
      before_action :authenticate_user!
      around_action :handle_known_exceptions

      KEY = '242644e8afe2d587e8ddb6e1f82001e3968ec7e7054fb1dc3795ee1652aac6ce13416d632cd94f7b3c951a7ed2033696913fbac658b533172b089ce6af4418a2'

      def token_for_user(user, data = {})
        Token.token_for_user(user, data)
      end

      def authenticate_user!
        unless user_id_in_token?
          render json: { errors: ['Not Authenticated'] }, status: :unauthorized
          return
        end

        token = Token.where(token: http_token, user_id: auth_token[:user_id]).last
        validate_token(token)
        @current_user = token.user
      rescue JWT::VerificationError, JWT::DecodeError, ActiveRecord::RecordNotFound => e
        raise e
      end

      def current_user
        @current_user || Token.where(token: http_token, user_id: auth_token[:user_id]).last&.user
      rescue StandardError
        nil
      end

      def user_id_in_token?
        http_token && auth_token && auth_token[:user_id].to_i
      end

      def validate_token(token)
        unless token
          render json: { errors: ['Invalid token'] }, status: :unauthorized
          return
        end
        if token.updated_at < 720.to_i.minutes.ago
          render json: { errors: ['Session expired'] }, status: :unauthorized
          return
        end
        if token.created_at < 720.to_i.minutes.ago
          render json: { errors: ['Session force expired'] }, status: :unauthorized
          return
        end

        token.update(updated_at: Time.now)
      end

      def http_token
        @http_token ||= (request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?)
      end

      def auth_token
        @auth_token ||= decode_token(http_token)
      end

      def decode_token(token)
        HashWithIndifferentAccess.new(JWT.decode(token, KEY)[0])
      rescue StandardError
        nil
        # JsonWebToken.decode(token)
      end

      def handle_known_exceptions
        yield
      rescue JWT::VerificationError, JWT::DecodeError, ActiveRecord::RecordNotFound => e
        render json: { errors: [e.message] }, status: :unauthorized
      end
    end
  end
end
