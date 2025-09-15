module V1
  class Workouts < Grape::API
    resource :workout_summaries do
      desc 'ワークアウトサマリーの一覧を取得'
      get do
        workout_summaries = WorkoutSummary.all
        present workout_summaries, with: Entities::WorkoutSummary
      end
    end

    resource :workout_blocks do
      desc '指定したサマリーIDのワークアウトブロックを取得'
      params do
        requires :id, type: Integer, desc: 'ワークアウトサマリーID'
      end
      get ':id' do
        workout_blocks = WorkoutBlock.where(workout_summary_id: params[:id])
        present workout_blocks, with: Entities::WorkoutBlock
      end
    end
  end
end
