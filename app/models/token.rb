# frozen_string_literal: true

require 'json_web_token'
# tocken
class Token < ApplicationRecord
  belongs_to :user

  validates_presence_of :user, :token

  default_scope { order(created_at: :desc) }

  def self.token_for_user(user, data = {})
    data = {
      user_id: user.id,
      generated_at: Time.now
      # exp: 720.minutes.from_now.to_i
    }.merge(data)

    token = JsonWebToken.encode(data)
    user.tokens.create(token: token)
    token
  end
end
