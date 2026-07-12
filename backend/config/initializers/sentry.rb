# frozen_string_literal: true

# エラー監視（Sentry）。SENTRY_DSN が未設定の環境では何も送信しない。
Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.enabled_environments = %w[production]
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # 個人情報（IPアドレス・リクエストボディ等）は送らない
  config.send_default_pii = false

  # パフォーマンストレースは全体の10%をサンプリング
  config.traces_sample_rate = 0.1
end
