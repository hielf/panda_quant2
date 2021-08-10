class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # Rack::Attack.throttled_response = lambda do |env|
  #   [ 200, { 'Content-Type' => 'application/json' }, [{ status: 0, message: "Too many requests!!!", error: "Too many requests!!!" }.to_json] ]
  # end

  throttle('wechat api', limit: 1, period: 1.seconds) do |req|
    if req.path == '/wechat' && req.post?
      req.ip
    end
  end
end
