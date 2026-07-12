# frozen_string_literal: true

class Rack::Attack
  # ActionDispatch::RemoteIp が算出した実クライアントIPを使う。
  # req.ip（Rack標準）は Cloudflare のエッジIPを返すことがあり、その場合
  # 全ユーザーが同じIPとしてカウントされてレート制限を共有してしまう。
  # RemoteIp ミドルウェアは Rack::Attack より先に実行される（config/initializers/trusted_proxies.rb 参照）。
  def self.client_ip(req)
    (req.env['action_dispatch.remote_ip'] || req.ip).to_s
  end

  # Allow local traffic (health checks, localhost)
  safelist('allow-localhost') do |req|
    client_ip(req) == '127.0.0.1' || client_ip(req) == '::1'
  end

  # Throttle by IP: 100 requests per 1 minute per IP
  throttle('req/ip', limit: 100, period: 1.minute) do |req|
    client_ip(req)
  end

  # Strict throttle for auth endpoint: 10 attempts per minute per IP
  throttle('auth/ip', limit: 10, period: 1.minute) do |req|
    client_ip(req) if req.path == '/api/v1/auth/google' && req.post?
  end
end
