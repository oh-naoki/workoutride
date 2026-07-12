# frozen_string_literal: true

# Cloudflare を経由したリクエストで実クライアントIPを取得するための設定。
# Cloudflare のエッジIPを信頼済みプロキシとして扱わないと、remote_ip が
# エッジIPを返してしまい、レート制限が全ユーザー共有になる・アクセスログが
# 意味をなさない等の問題が起きる。
#
# IPレンジの出典: https://www.cloudflare.com/ips/ （変更は稀だが、更新時はここを差し替える）
cloudflare_ip_ranges = %w[
  173.245.48.0/20
  103.21.244.0/22
  103.22.200.0/22
  103.31.4.0/22
  141.101.64.0/18
  108.162.192.0/18
  190.93.240.0/20
  188.114.96.0/20
  197.234.240.0/22
  198.41.128.0/17
  162.158.0.0/15
  104.16.0.0/13
  104.24.0.0/14
  172.64.0.0/13
  131.0.72.0/22
  2400:cb00::/32
  2606:4700::/32
  2803:f800::/32
  2405:b500::/32
  2405:8100::/32
  2a06:98c0::/29
  2c0f:f248::/32
].map { |cidr| IPAddr.new(cidr) }

# デフォルトの信頼済みプロキシ（ループバック・プライベートIP = kamal-proxy 等）に
# Cloudflare のレンジを追加する
Rails.application.config.action_dispatch.trusted_proxies =
  ActionDispatch::RemoteIp::TRUSTED_PROXIES + cloudflare_ip_ranges
