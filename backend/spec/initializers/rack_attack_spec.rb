require 'rails_helper'

RSpec.describe Rack::Attack do
  describe '.client_ip' do
    it 'RemoteIpが算出した実クライアントIPを優先する' do
      req = Rack::Attack::Request.new(
        'REMOTE_ADDR' => '104.16.0.1', # Cloudflare edge
        'action_dispatch.remote_ip' => IPAddr.new('203.0.113.10')
      )

      expect(described_class.client_ip(req)).to eq('203.0.113.10')
    end

    it 'RemoteIpがない場合はreq.ipにフォールバックする' do
      req = Rack::Attack::Request.new('REMOTE_ADDR' => '198.51.100.5')

      expect(described_class.client_ip(req)).to eq('198.51.100.5')
    end
  end

  describe 'trusted proxies設定' do
    it 'CloudflareのIPレンジが信頼済みプロキシに含まれる' do
      proxies = Rails.application.config.action_dispatch.trusted_proxies

      expect(proxies.any? { |p| p.include?(IPAddr.new('104.16.0.1')) }).to be(true)
      # ループバック（kamal-proxy等）も引き続き信頼される
      expect(proxies.any? { |p| p.include?(IPAddr.new('127.0.0.1')) }).to be(true)
      # 一般のグローバルIPは信頼されない
      expect(proxies.any? { |p| p.include?(IPAddr.new('203.0.113.10')) }).to be(false)
    end
  end
end
