require 'rails_helper'

RSpec.describe AuthToken, type: :model do
  let(:user) { User.create!(provider: 'google', uid: '12345') }

  describe 'トークン生成' do
    it '生トークンをメモリ上に、ダイジェストのみをDBに保存する' do
      auth_token = user.auth_tokens.create!

      expect(auth_token.token).to be_present
      expect(auth_token.token_digest).to eq(described_class.digest(auth_token.token))
      expect(auth_token.reload.attributes).not_to have_key('token')
    end

    it '生トークンはリロード後に取得できない' do
      auth_token = user.auth_tokens.create!

      expect(described_class.find(auth_token.id).token).to be_nil
    end
  end

  describe '.find_active_by_raw_token' do
    it '有効な生トークンでレコードを引ける' do
      auth_token = user.auth_tokens.create!

      found = described_class.find_active_by_raw_token(auth_token.token)
      expect(found).to eq(auth_token)
      expect(found.user).to eq(user)
    end

    it '期限切れトークンでは引けない' do
      auth_token = user.auth_tokens.create!
      auth_token.update!(expires_at: 1.hour.ago)

      expect(described_class.find_active_by_raw_token(auth_token.token)).to be_nil
    end

    it '不正なトークンでは引けない' do
      user.auth_tokens.create!

      expect(described_class.find_active_by_raw_token('invalid-token')).to be_nil
    end
  end
end
