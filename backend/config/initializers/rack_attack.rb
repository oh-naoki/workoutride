# frozen_string_literal: true

class Rack::Attack
  # Allow local traffic (health checks, localhost)
  safelist('allow-localhost') do |req|
    # fly.io, render, or local loopback
    req.ip == '127.0.0.1' || req.ip == '::1'
  end

  # Throttle by IP: 100 requests per 1 minute per IP
  throttle('req/ip', limit: 100, period: 1.minute) do |req|
    req.ip
  end

  # Strict throttle for auth endpoint: 10 attempts per minute per IP
  throttle('auth/ip', limit: 10, period: 1.minute) do |req|
    req.ip if req.path == '/api/v1/auth/google' && req.post?
  end
end


