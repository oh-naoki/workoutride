module Entities
  class WorkoutBlock < Grape::Entity
    expose :id
    expose :workout_summary_id
    expose :order_index
    expose :target_ftp_percentage
    expose :duration
    expose :block_type, documentation: { desc: 'ブロックカテゴリ名' } do |block|
      block.block_category.name
    end
    expose :created_at
    expose :updated_at
  end
end
