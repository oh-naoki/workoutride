class User < ApplicationRecord
  has_many :auth_tokens, dependent: :destroy
  has_many :workout_results, dependent: :destroy
  has_many :user_ftps, dependent: :destroy

  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }

  def google?
    provider == 'google'
  end
end
