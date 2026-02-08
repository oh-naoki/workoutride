class AddUserToWorkoutResults < ActiveRecord::Migration[8.0]
  def change
    add_reference :workout_results, :user, null: true, foreign_key: true
  end
end
