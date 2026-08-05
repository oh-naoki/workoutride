require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:auth_tokens).dependent(:destroy) }
    it { should have_many(:workout_results).dependent(:destroy) }
    it { should have_many(:user_ftps).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:uid) }

    it 'validates uniqueness of uid scoped to provider' do
      create(:user, provider: 'google', uid: 'dup-uid')
      duplicate = build(:user, provider: 'google', uid: 'dup-uid')

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:uid]).to be_present
    end

    it 'allows the same uid across different providers' do
      create(:user, provider: 'google', uid: 'shared-uid')
      other_provider = build(:user, provider: 'system', uid: 'shared-uid')

      expect(other_provider).to be_valid
    end
  end

  describe '#google?' do
    it 'returns true for google provider' do
      expect(build(:user, provider: 'google')).to be_google
    end

    it 'returns false for other providers' do
      expect(build(:user, provider: 'system')).not_to be_google
    end
  end
end
