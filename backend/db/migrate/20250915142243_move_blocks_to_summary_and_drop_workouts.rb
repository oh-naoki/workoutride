class MoveBlocksToSummaryAndDropWorkouts < ActiveRecord::Migration[8.0]
  def up
    # 1) 新しい参照を追加
    add_reference :workout_blocks, :workout_summary, null: true, foreign_key: true

    # 2) 既存データの移行
    say_with_time 'Backfilling workout_summary_id on workout_blocks' do
      execute <<~SQL
        UPDATE workout_blocks wb
        SET workout_summary_id = w.workout_summary_id
        FROM workouts w
        WHERE wb.workout_id = w.id
      SQL
    end

    # 3) NOT NULL 制約を付与
    change_column_null :workout_blocks, :workout_summary_id, false

    # 4) 旧外部キー/カラムを削除（存在する場合のみ）
    if foreign_key_exists?(:workout_blocks, :workouts)
      remove_foreign_key :workout_blocks, :workouts
    end

    if column_exists?(:workout_blocks, :workout_id)
      # remove_reference で foreign_key: true を付けると再度FK削除を試みるため付けない
      remove_reference :workout_blocks, :workout
    end
  end

  def down
    # 逆マイグレーション: workout_id を復元
    add_reference :workout_blocks, :workout, null: true
    add_foreign_key :workout_blocks, :workouts if table_exists?(:workouts)

    say_with_time 'Restoring workout_id on workout_blocks from workout_summary_id' do
      execute <<~SQL
        UPDATE workout_blocks wb
        SET workout_id = w.id
        FROM workouts w
        WHERE w.workout_summary_id = wb.workout_summary_id
      SQL
    end

    change_column_null :workout_blocks, :workout_id, false

    if foreign_key_exists?(:workout_blocks, :workout_summaries)
      remove_foreign_key :workout_blocks, :workout_summaries
    end
    remove_reference :workout_blocks, :workout_summary if column_exists?(:workout_blocks, :workout_summary_id)
  end
end
