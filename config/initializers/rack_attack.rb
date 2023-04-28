# frozen_string_literal: true
class Rack::Attack
  # Rake::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  Rack::Attack.throttle('req/ip', limit: 5, period: 1.minute) do |req|
    # Throttle requests to api/v1 to 10 requests per 10 seconds
    if req.path == '/api/v1/pages'
      req.ip + req.path
    else
      req.ip
    end 
  end

  Rack::Attack.throttle('sign_up', limit: 3, period: 2.minute) do |req|
      # Throttle requests to api/v1 to 10 requests per 10 seconds
      if req.path == 'api/v1/pages' && req.post?
        req.ip + req.path
      else
        req.ip
      end 
    end 
end
