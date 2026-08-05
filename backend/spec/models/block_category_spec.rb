require 'rails_helper'

RSpec.describe BlockCategory, type: :model do
  describe 'associations' do
    it { should have_many(:workout_blocks) }
  end

  describe 'validations' do
    subject { create(:block_category) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
