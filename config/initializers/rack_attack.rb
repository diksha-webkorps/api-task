Rack::Attack.blocklist("allow2ban login scrapers") do |req|
  Rack::Attack::Allow2Ban.filter(
  req.ip,
  maxretry: 3,
  findtime: 1.minute,
  bantime: 1.hour
  ) do
    req.path == "/api/v1/pages" && req.post?
  end
end
