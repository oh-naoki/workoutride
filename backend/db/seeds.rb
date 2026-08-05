# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Creating Zwift-based cycling training menus..."

# 既存のデータをクリア
WorkoutSummary.destroy_all

categories = Hash.new { |h, name| h[name] = Category.find_or_create_by!(name: name) }
block_categories = Hash.new { |h, name| h[name] = BlockCategory.find_or_create_by!(name: name) }

# order_indexによる連番は表示側の責務なので、block_categoryにはベースとなる
# カテゴリ名のみを持たせる（「インターバル1」ではなく「インターバル」）。

# 1. Sweet Spot Training (SST)
sst_summary = WorkoutSummary.create!(
  name: "Sweet Spot Training (SST)",
  total_duration: 75, # 15分ウォームアップ + 3×15分 + 2×5分間 + 10分クールダウン
  category: categories["FTP向上"]
)

sst_summary.workout_blocks.create!([
  { order_index: 1, duration: 900, block_category: block_categories["ウォームアップ"], target_ftp_percentage: 60 }, # 15分
  { order_index: 2, duration: 900, block_category: block_categories["メインセット"], target_ftp_percentage: 90 }, # 15分
  { order_index: 3, duration: 300, block_category: block_categories["軽いペダリング"], target_ftp_percentage: 50 }, # 5分
  { order_index: 4, duration: 900, block_category: block_categories["メインセット"], target_ftp_percentage: 90 }, # 15分
  { order_index: 5, duration: 300, block_category: block_categories["軽いペダリング"], target_ftp_percentage: 50 }, # 5分
  { order_index: 6, duration: 900, block_category: block_categories["メインセット"], target_ftp_percentage: 90 }, # 15分
  { order_index: 7, duration: 600, block_category: block_categories["クールダウン"], target_ftp_percentage: 50 } # 10分
])

# 2. VO2 Max Intervals - 強度を120-130%に修正
vo2_summary = WorkoutSummary.create!(
  name: "VO2 Max Intervals",
  total_duration: 60, # 10分ウォームアップ + 6×3分 + 5×3分間 + 10分クールダウン
  category: categories["最大酸素摂取量向上"]
)

vo2_summary.workout_blocks.create!([
  { order_index: 1, duration: 600, block_category: block_categories["ウォームアップ"], target_ftp_percentage: 60 }, # 10分
  { order_index: 2, duration: 180, block_category: block_categories["インターバル"], target_ftp_percentage: 125 }, # 3分 - 125%
  { order_index: 3, duration: 180, block_category: block_categories["軽いペダリング"], target_ftp_percentage: 50 }, # 3分
  { order_index: 4, duration: 180, block_category: block_categories["インターバル"], target_ftp_percentage: 125 }, # 3分 - 125%
  { order_index: 5, duration: 180, block_category: block_categories["軽いペダリング"], target_ftp_percentage: 50 }, # 3分
  { order_index: 6, duration: 180, block_category: block_categories["インターバル"], target_ftp_percentage: 125 }, # 3分 - 125%
  { order_index: 7, duration: 180, block_category: block_categories["軽いペダリング"], target_ftp_percentage: 50 }, # 3分
  { order_index: 8, duration: 180, block_category: block_categories["インターバル"], target_ftp_percentage: 125 }, # 3分 - 125%
  { order_index: 9, duration: 180, block_category: block_categories["軽いペダリング"], target_ftp_percentage: 50 }, # 3分
  { order_index: 10, duration: 180, block_category: block_categories["インターバル"], target_ftp_percentage: 125 }, # 3分 - 125%
  { order_index: 11, duration: 180, block_category: block_categories["軽いペダリング"], target_ftp_percentage: 50 }, # 3分
  { order_index: 12, duration: 180, block_category: block_categories["インターバル"], target_ftp_percentage: 125 }, # 3分 - 125%
  { order_index: 13, duration: 600, block_category: block_categories["クールダウン"], target_ftp_percentage: 50 } # 10分
])

# 3. Threshold Intervals
threshold_summary = WorkoutSummary.create!(
  name: "Threshold Intervals",
  total_duration: 70, # 10分ウォームアップ + 2×20分 + 10分間 + 10分クールダウン
  category: categories["乳酸閾値向上"]
)

threshold_summary.workout_blocks.create!([
  { order_index: 1, duration: 600, block_category: block_categories["ウォームアップ"], target_ftp_percentage: 60 }, # 10分
  { order_index: 2, duration: 1200, block_category: block_categories["閾値セット"], target_ftp_percentage: 95 }, # 20分
  { order_index: 3, duration: 600, block_category: block_categories["軽いペダリング"], target_ftp_percentage: 50 }, # 10分
  { order_index: 4, duration: 1200, block_category: block_categories["閾値セット"], target_ftp_percentage: 95 }, # 20分
  { order_index: 5, duration: 600, block_category: block_categories["クールダウン"], target_ftp_percentage: 50 } # 10分
])

# 4. Endurance Ride
endurance_summary = WorkoutSummary.create!(
  name: "Endurance Ride",
  total_duration: 120, # 10分ウォームアップ + 2×45分 + 10分間 + 10分クールダウン
  category: categories["基礎持久力向上"]
)

endurance_summary.workout_blocks.create!([
  { order_index: 1, duration: 600, block_category: block_categories["ウォームアップ"], target_ftp_percentage: 60 }, # 10分
  { order_index: 2, duration: 2700, block_category: block_categories["エンデュランス"], target_ftp_percentage: 75 }, # 45分
  { order_index: 3, duration: 600, block_category: block_categories["軽いペダリング"], target_ftp_percentage: 50 }, # 10分
  { order_index: 4, duration: 2700, block_category: block_categories["エンデュランス"], target_ftp_percentage: 75 }, # 45分
  { order_index: 5, duration: 600, block_category: block_categories["クールダウン"], target_ftp_percentage: 50 } # 10分
])

# 5. Sprint Intervals - 強度を150%に修正
sprint_summary = WorkoutSummary.create!(
  name: "Sprint Intervals",
  total_duration: 75, # 10分ウォームアップ + 10×30秒 + 9×4分間 + 10分クールダウン
  category: categories["短時間高出力向上"]
)

sprint_blocks = []
sprint_blocks << { order_index: 1, duration: 600, block_category: block_categories["ウォームアップ"], target_ftp_percentage: 60 } # 10分

# 10回のスプリントインターバル - 150%の強度
(1..10).each do |i|
  sprint_blocks << { order_index: i * 2, duration: 30, block_category: block_categories["スプリント"], target_ftp_percentage: 150 } # 30秒 - 150%
  if i < 10
    sprint_blocks << { order_index: i * 2 + 1, duration: 240, block_category: block_categories["軽いペダリング"], target_ftp_percentage: 50 } # 4分
  end
end

sprint_blocks << { order_index: 21, duration: 600, block_category: block_categories["クールダウン"], target_ftp_percentage: 50 } # 10分
sprint_summary.workout_blocks.create!(sprint_blocks)

# 6. Hill Climb Training
hill_summary = WorkoutSummary.create!(
  name: "Hill Climb Training",
  total_duration: 65, # 10分ウォームアップ + 5×8分 + 4×5分間 + 10分クールダウン
  category: categories["登坂能力向上"]
)

hill_blocks = []
hill_blocks << { order_index: 1, duration: 600, block_category: block_categories["ウォームアップ"], target_ftp_percentage: 60 } # 10分

# 5回のヒルクライム
(1..5).each do |i|
  hill_blocks << { order_index: i * 2, duration: 480, block_category: block_categories["ヒルクライム"], target_ftp_percentage: 100 } # 8分
  if i < 5
    hill_blocks << { order_index: i * 2 + 1, duration: 300, block_category: block_categories["軽いペダリング"], target_ftp_percentage: 50 } # 5分
  end
end

hill_blocks << { order_index: 11, duration: 600, block_category: block_categories["クールダウン"], target_ftp_percentage: 50 } # 10分
hill_summary.workout_blocks.create!(hill_blocks)

# 7. Tempo Ride
tempo_summary = WorkoutSummary.create!(
  name: "Tempo Ride",
  total_duration: 85, # 10分ウォームアップ + 3×15分 + 2×8分間 + 10分クールダウン
  category: categories["中強度持久力向上"]
)

tempo_summary.workout_blocks.create!([
  { order_index: 1, duration: 600, block_category: block_categories["ウォームアップ"], target_ftp_percentage: 60 }, # 10分
  { order_index: 2, duration: 900, block_category: block_categories["テンポ"], target_ftp_percentage: 85 }, # 15分
  { order_index: 3, duration: 480, block_category: block_categories["軽いペダリング"], target_ftp_percentage: 50 }, # 8分
  { order_index: 4, duration: 900, block_category: block_categories["テンポ"], target_ftp_percentage: 85 }, # 15分
  { order_index: 5, duration: 480, block_category: block_categories["軽いペダリング"], target_ftp_percentage: 50 }, # 8分
  { order_index: 6, duration: 900, block_category: block_categories["テンポ"], target_ftp_percentage: 85 }, # 15分
  { order_index: 7, duration: 600, block_category: block_categories["クールダウン"], target_ftp_percentage: 50 } # 10分
])

# 8. Crit Race Simulation - 強度を110%に修正
crit_summary = WorkoutSummary.create!(
  name: "Crit Race Simulation",
  total_duration: 80, # 10分ウォームアップ + 4セット(8×2分 + 7×2分間) + 10分クールダウン
  category: categories["レース対応能力向上"]
)

crit_blocks = []
crit_blocks << { order_index: 1, duration: 600, block_category: block_categories["ウォームアップ"], target_ftp_percentage: 60 } # 10分

# 4セットのレースシミュレーション - ハード部分を110%に
(1..4).each do |set|
  (1..8).each do |i|
    crit_blocks << { order_index: (set - 1) * 16 + i * 2, duration: 120, block_category: block_categories["ハード"], target_ftp_percentage: 110 } # 2分 - 110%
    if i < 8
      crit_blocks << { order_index: (set - 1) * 16 + i * 2 + 1, duration: 120, block_category: block_categories["イージー"], target_ftp_percentage: 65 } # 2分
    end
  end
end

crit_blocks << { order_index: 65, duration: 600, block_category: block_categories["クールダウン"], target_ftp_percentage: 50 } # 10分
crit_summary.workout_blocks.create!(crit_blocks)

# 9. Recovery Ride
recovery_summary = WorkoutSummary.create!(
  name: "Recovery Ride",
  total_duration: 60, # 60分間の軽いペダリング
  category: categories["回復促進"]
)

recovery_summary.workout_blocks.create!([
  { order_index: 1, duration: 3600, block_category: block_categories["リカバリーライド"], target_ftp_percentage: 55 } # 60分
])

# 10. Time Trial Practice
tt_summary = WorkoutSummary.create!(
  name: "Time Trial Practice",
  total_duration: 75, # 10分ウォームアップ + 2×20分 + 15分間 + 10分クールダウン
  category: categories["個人タイムトライアル対応"]
)

tt_summary.workout_blocks.create!([
  { order_index: 1, duration: 600, block_category: block_categories["ウォームアップ"], target_ftp_percentage: 60 }, # 10分
  { order_index: 2, duration: 1200, block_category: block_categories["TTセット"], target_ftp_percentage: 95 }, # 20分
  { order_index: 3, duration: 900, block_category: block_categories["軽いペダリング"], target_ftp_percentage: 50 }, # 15分
  { order_index: 4, duration: 1200, block_category: block_categories["TTセット"], target_ftp_percentage: 95 }, # 20分
  { order_index: 5, duration: 600, block_category: block_categories["クールダウン"], target_ftp_percentage: 50 } # 10分
])

puts "Created #{WorkoutSummary.count} training menus with #{WorkoutBlock.count} total blocks"
puts "Training menus:"
WorkoutSummary.includes(:category).each do |summary|
  puts "- #{summary.name} (#{summary.category.name}) - #{summary.total_duration}分"
end

puts "\n強度設定の確認:"
puts "VO2 Max Intervals: 最大125% (FTPの125%)"
puts "Sprint Intervals: 最大150% (FTPの150%)"
puts "Crit Race Simulation: 最大110% (FTPの110%)"
puts "その他: 適切な強度範囲で設定"
