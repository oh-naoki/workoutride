require 'rails_helper'

RSpec.describe WorkoutBlock, type: :model do
  describe 'associations' do
    it { should belong_to(:workout_summary) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      workout_block = build(:workout_block)
      expect(workout_block).to be_valid
    end
  end

  describe 'default scope' do
    it 'orders by order_index in ascending order' do
      workout_summary = create(:workout_summary)
      block_3 = create(:workout_block, workout_summary: workout_summary, order_index: 2)
      block_1 = create(:workout_block, workout_summary: workout_summary, order_index: 0)
      block_2 = create(:workout_block, workout_summary: workout_summary, order_index: 1)

      expect(WorkoutBlock.all.to_a).to eq([block_1, block_2, block_3])
    end
  end

  describe 'attributes' do
    let(:workout_block) { create(:workout_block) }

    it 'has required attributes' do
      expect(workout_block).to respond_to(:order_index)
      expect(workout_block).to respond_to(:target_ftp_percentage)
      expect(workout_block).to respond_to(:duration)
      expect(workout_block).to respond_to(:block_type)
    end
  end
end
