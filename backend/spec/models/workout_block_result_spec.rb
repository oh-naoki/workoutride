require 'rails_helper'

RSpec.describe WorkoutBlockResult, type: :model do
  describe 'associations' do
    it { should belong_to(:workout_result) }
    it { should belong_to(:workout_block) }
  end

  describe 'validations' do
    it { should validate_presence_of(:duration_seconds) }
    it { should validate_numericality_of(:duration_seconds).is_greater_than_or_equal_to(0) }
  end
end
