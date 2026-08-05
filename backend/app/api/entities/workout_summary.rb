module Entities
  class WorkoutSummary < Grape::Entity
    expose :id
    expose :name
    expose :total_duration
    expose :category, documentation: { desc: 'カテゴリ名' } do |summary|
      summary.category.name
    end
    expose :created_at
    expose :updated_at
  end
end
