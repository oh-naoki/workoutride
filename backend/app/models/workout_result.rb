class WorkoutResult < ApplicationRecord
  belongs_to :workout_summary
  has_many :workout_block_results, dependent: :destroy

  validates :started_at, presence: true
  validates :total_duration_seconds, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: %w[completed abandoned] }
end
