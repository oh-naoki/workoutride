class MigrateExistingDataToSystemUser < ActiveRecord::Migration[8.0]
  def up
    # Create system user
    system_user = User.find_or_create_by!(
      provider: 'system',
      uid: 'system'
    )

    # Migrate existing workout_results to system user
    WorkoutResult.where(user_id: nil).update_all(user_id: system_user.id)

    # Migrate existing user_ftps to system user
    UserFtp.where(user_id: nil).update_all(user_id: system_user.id)
  end

  def down
    # Find system user
    system_user = User.find_by(provider: 'system', uid: 'system')
    return unless system_user

    # Reset user_id for records owned by system user
    WorkoutResult.where(user_id: system_user.id).update_all(user_id: nil)
    UserFtp.where(user_id: system_user.id).update_all(user_id: nil)
  end
end
