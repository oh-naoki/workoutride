class AuthToken < ApplicationRecord
  belongs_to :user

  # 生トークンは作成直後のレスポンス用にメモリ上でのみ保持し、DBにはダイジェストだけを保存する
  attr_reader :token

  before_create :generate_token, :set_expiration

  scope :active, -> { where('expires_at > ?', Time.current) }

  def self.digest(raw_token)
    Digest::SHA256.hexdigest(raw_token)
  end

  def self.find_active_by_raw_token(raw_token)
    includes(:user).active.find_by(token_digest: digest(raw_token))
  end

  def expired?
    expires_at < Time.current
  end

  def touch_last_used!
    update_column(:last_used_at, Time.current)
  end

  private

  def generate_token
    @token = SecureRandom.hex(32)
    self.token_digest = self.class.digest(@token)
  end

  def set_expiration
    self.expires_at = 30.days.from_now
  end
end
