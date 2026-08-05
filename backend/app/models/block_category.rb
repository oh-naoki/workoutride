class BlockCategory < ApplicationRecord
  has_many :workout_blocks, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
end
