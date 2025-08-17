class RenameTargetPwrToTargetFtpPercentage < ActiveRecord::Migration[8.0]
  def change
    rename_column :workout_blocks, :target_pwr, :target_ftp_percentage
  end
end
