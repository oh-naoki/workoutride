class AddTargetPwrToWorkoutBlocks < ActiveRecord::Migration[8.0]
  def change
    # target_pwrカラムを追加（精度指定：10,2 = 小数点2位まで）
    add_column :workout_blocks, :target_pwr, :decimal, precision: 10, scale: 2
    
    # 既存データをtarget_powerからtarget_pwrに変換（60kgを基準としてPWR化）
    reversible do |dir|
      dir.up do
        # target_powerからtarget_pwrに変換
        execute <<-SQL
          UPDATE workout_blocks SET target_pwr = ROUND(target_power / 60.0, 2) WHERE target_power IS NOT NULL;
        SQL
      end
      
      dir.down do
        # target_pwrからtarget_powerに復元
        execute <<-SQL
          UPDATE workout_blocks SET target_power = ROUND(target_pwr * 60.0) WHERE target_pwr IS NOT NULL;
        SQL
      end
    end
    
    # target_powerカラムを削除
    remove_column :workout_blocks, :target_power, :integer
  end
end
