module V1
  class WorkoutResults < Grape::API
    resource :workout_results do
      desc 'ワークアウト結果の一覧を取得'
      params do
        optional :workout_summary_id, type: Integer, desc: 'ワークアウトサマリーIDでフィルタ'
      end
      get do
        results = ::WorkoutResult.includes(:workout_block_results).order(created_at: :desc)
        results = results.where(workout_summary_id: params[:workout_summary_id]) if params[:workout_summary_id]
        present results, with: Entities::WorkoutResult
      end

      desc 'ワークアウト結果の詳細を取得'
      params do
        requires :id, type: Integer, desc: 'ワークアウト結果ID'
      end
      get ':id' do
        result = ::WorkoutResult.includes(:workout_block_results).find(params[:id])
        present result, with: Entities::WorkoutResult
      end

      desc 'ワークアウト結果を保存'
      params do
        requires :workout_summary_id, type: Integer, desc: 'ワークアウトサマリーID'
        requires :started_at, type: String, desc: '開始時刻 (ISO8601)'
        optional :finished_at, type: String, desc: '終了時刻 (ISO8601)'
        requires :total_duration_seconds, type: Integer, desc: '合計時間（秒）'
        optional :average_power, type: Integer, desc: '平均パワー'
        optional :max_power, type: Integer, desc: '最大パワー'
        optional :average_cadence, type: Integer, desc: '平均ケイデンス'
        requires :status, type: String, values: %w[completed abandoned], desc: 'ステータス'
        optional :workout_block_results, type: Array do
          requires :workout_block_id, type: Integer, desc: 'ワークアウトブロックID'
          optional :average_power, type: Integer, desc: '平均パワー'
          optional :max_power, type: Integer, desc: '最大パワー'
          optional :average_cadence, type: Integer, desc: '平均ケイデンス'
          requires :duration_seconds, type: Integer, desc: '実績時間（秒）'
        end
      end
      post do
        result = ::WorkoutResult.new(
          workout_summary_id: params[:workout_summary_id],
          started_at: params[:started_at],
          finished_at: params[:finished_at],
          total_duration_seconds: params[:total_duration_seconds],
          average_power: params[:average_power],
          max_power: params[:max_power],
          average_cadence: params[:average_cadence],
          status: params[:status]
        )

        if params[:workout_block_results].present?
          params[:workout_block_results].each do |br|
            result.workout_block_results.build(
              workout_block_id: br[:workout_block_id],
              average_power: br[:average_power],
              max_power: br[:max_power],
              average_cadence: br[:average_cadence],
              duration_seconds: br[:duration_seconds]
            )
          end
        end

        result.save!
        present result, with: Entities::WorkoutResult
      end
    end
  end
end
