class MakeUserIdRequiredOnUserFtpsAndWorkoutResults < ActiveRecord::Migration[8.0]
  def up
    raise 'user_ftps has rows with null user_id' if UserFtp.where(user_id: nil).exists?
    raise 'workout_results has rows with null user_id' if WorkoutResult.where(user_id: nil).exists?

    change_column_null :user_ftps, :user_id, false
    change_column_null :workout_results, :user_id, false
  end

  def down
    change_column_null :user_ftps, :user_id, true
    change_column_null :workout_results, :user_id, true
  end
end
