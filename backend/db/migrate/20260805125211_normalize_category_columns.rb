class NormalizeCategoryColumns < ActiveRecord::Migration[8.0]
  # マイグレーション内では本体のモデル定義に依存せず、専用のAR継承クラスを使う。
  class MigrationCategory < ActiveRecord::Base
    self.table_name = "categories"
  end

  class MigrationBlockCategory < ActiveRecord::Base
    self.table_name = "block_categories"
  end

  class MigrationWorkoutSummary < ActiveRecord::Base
    self.table_name = "workout_summaries"
  end

  class MigrationWorkoutBlock < ActiveRecord::Base
    self.table_name = "workout_blocks"
  end

  def up
    add_reference :workout_summaries, :category, foreign_key: true
    add_reference :workout_blocks, :block_category, foreign_key: true

    MigrationWorkoutSummary.reset_column_information
    MigrationWorkoutSummary.find_each do |summary|
      next if summary.category.blank?

      category = MigrationCategory.find_or_create_by!(name: summary.category)
      summary.update_column(:category_id, category.id)
    end

    # block_typeは「メインセット1」のようにカテゴリ名+連番が混在しているため、
    # 末尾の数字・ハイフンを除いた部分を真のカテゴリとして正規化する。
    MigrationWorkoutBlock.reset_column_information
    MigrationWorkoutBlock.find_each do |block|
      next if block.block_type.blank?

      base_name = block.block_type.sub(/[\d\-]+\z/, "")
      block_category = MigrationBlockCategory.find_or_create_by!(name: base_name)
      block.update_column(:block_category_id, block_category.id)
    end

    change_column_null :workout_summaries, :category_id, false
    change_column_null :workout_blocks, :block_category_id, false

    remove_column :workout_summaries, :category
    remove_column :workout_blocks, :block_type
  end

  def down
    add_column :workout_summaries, :category, :string
    add_column :workout_blocks, :block_type, :string

    MigrationWorkoutSummary.reset_column_information
    MigrationWorkoutSummary.find_each do |summary|
      category = MigrationCategory.find_by(id: summary.category_id)
      summary.update_column(:category, category&.name)
    end

    # 注意: block_typeに埋め込まれていた連番(「インターバル1」等)は正規化時に破棄しているため、
    # ロールバックしてもカテゴリ名のみ（連番なし）しか復元できない。
    MigrationWorkoutBlock.reset_column_information
    MigrationWorkoutBlock.find_each do |block|
      block_category = MigrationBlockCategory.find_by(id: block.block_category_id)
      block.update_column(:block_type, block_category&.name)
    end

    remove_reference :workout_summaries, :category, foreign_key: true
    remove_reference :workout_blocks, :block_category, foreign_key: true
  end
end
