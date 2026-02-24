class AuthToken < ApplicationRecord
  belongs_to :user

  before_create :generate_token, :set_expiration

  scope :active, -> { where('expires_at > ?', Time.current) }

  def expired?
    expires_at < Time.current
  end

  def touch_last_used!
    update_column(:last_used_at, Time.current)
  end

  private

  def generate_token
    self.token = SecureRandom.hex(32)
  end

  def set_expiration
    self.expires_at = 30.days.from_now
  end
end
