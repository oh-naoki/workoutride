require 'rails_helper'

RSpec.describe WorkoutResult, type: :model do
  describe 'associations' do
    it { should belong_to(:workout_summary) }
    it { should have_many(:workout_block_results).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:started_at) }
    it { should validate_presence_of(:total_duration_seconds) }
    it { should validate_numericality_of(:total_duration_seconds).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(%w[completed abandoned]) }
  end
end
