module V1
  class Workouts < Grape::API
    helpers do
      include ::Helpers::AuthHelper
    end

    before do
      authenticate!
    end

    resource :workout_summaries do
      desc 'ワークアウトサマリーの一覧を取得'
      params do
        optional :page, type: Integer, default: 1, values: ->(v) { v >= 1 }, desc: 'ページ番号'
        optional :per_page, type: Integer, default: 100, values: ->(v) { v.between?(1, 200) }, desc: '1ページあたりの件数(最大200)'
      end
      get do
        workout_summaries = WorkoutSummary.order(:id)
        header 'X-Total-Count', workout_summaries.count.to_s
        workout_summaries = workout_summaries.limit(params[:per_page]).offset((params[:page] - 1) * params[:per_page])
        present workout_summaries, with: Entities::WorkoutSummary
      end

      desc 'ワークアウトサマリーの詳細を取得'
      params do
        requires :id, type: Integer, desc: 'ワークアウトサマリーID'
      end
      get ':id' do
        workout_summary = WorkoutSummary.find(params[:id])
        present workout_summary, with: Entities::WorkoutSummary
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
