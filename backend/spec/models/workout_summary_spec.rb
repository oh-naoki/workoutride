require 'rails_helper'

RSpec.describe WorkoutSummary, type: :model do
  describe 'associations' do
    it { should belong_to(:category) }
    it { should have_many(:workout_blocks).dependent(:destroy) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      workout_summary = build(:workout_summary)
      expect(workout_summary).to be_valid
    end
  end

  describe 'dependent destroy' do
    it 'destroys associated workout blocks when deleted' do
      workout_summary = create(:workout_summary)
      create_list(:workout_block, 3, workout_summary: workout_summary)

      expect { workout_summary.destroy }.to change { WorkoutBlock.count }.by(-3)
    end
  end

  describe 'workout blocks ordering' do
    it 'returns workout blocks in order_index order' do
      workout_summary = create(:workout_summary)
      block_3 = create(:workout_block, workout_summary: workout_summary, order_index: 2)
      block_1 = create(:workout_block, workout_summary: workout_summary, order_index: 0)
      block_2 = create(:workout_block, workout_summary: workout_summary, order_index: 1)

      expect(workout_summary.workout_blocks.to_a).to eq([block_1, block_2, block_3])
    end
  end
end
