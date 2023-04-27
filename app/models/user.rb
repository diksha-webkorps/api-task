# frozen_string_literal: true

# user
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :tokens

  def generate_jwt
    JWT.encode({ id: id,
                 exp: 1.days.from_now.to_i },
               Rails.application.secrets.secret_key_base)
  end
end
