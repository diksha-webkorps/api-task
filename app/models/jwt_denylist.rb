# frozen_string_literal: true

# jwtdenylist
class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  self.table_name = 'jwt_denylist'
end
