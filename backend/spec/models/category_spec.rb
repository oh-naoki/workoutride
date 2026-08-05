require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    it { should have_many(:workout_summaries) }
  end

  describe 'validations' do
    subject { create(:category) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
