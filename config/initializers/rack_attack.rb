class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # Rack::Attack.throttled_response = lambda do |env|
  #   [ 200, { 'Content-Type' => 'application/json' }, [{ status: 0, message: "Too many requests!!!", error: "Too many requests!!!" }.to_json] ]
  # end

  Rack::Attack.throttled_callback = lambda do |request|
    # NB: you have access to the name and other data about the matched throttle
    #  request.env['rack.attack.matched'],
    #  request.env['rack.attack.match_type'],
    #  request.env['rack.attack.match_data'],
    #  request.env['rack.attack.match_discriminator']

    # Using 503 because it may make attacker think that they have successfully
    # DOSed the site. Rack::Attack returns 429 for throttling by default
    [ 429, {}, ["Server Error\n"]]
  end

  Rack::Attack.throttle('wechat api', limit: 1, period: 1.seconds) do |req|
    if req.path == '/wechat' && req.post?
      req.ip
    end
  end
end
