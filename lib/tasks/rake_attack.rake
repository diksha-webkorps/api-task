namespace :attack do
    desc 'Start throttling'
    task start: :environment do
      Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
      use Rack::Attack
    end
  end