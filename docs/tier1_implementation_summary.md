# Tier 1 実装まとめ — ワークアウト結果記録（一気通貫）

## 概要

ワークアウトを実行し、結果が記録・閲覧できるという最も基本的なフローを、バックエンド（Rails API）からフロントエンド（Flutter）まで縦断で実装した。

---

## 1-1: seeds.rb 修正

- 旧スキーマの `sst_summary.workouts.create!`（中間テーブル `workouts` 経由）を全て削除
- `sst_summary.workout_blocks.create!`（直接関連）に変更
- 確認済み: `db:seed` で10メニュー・137ブロックが正常に作成される

### 変更ファイル

- `backend/db/seeds.rb`

---

## 1-2 & 1-3: DBマイグレーション

### workout_results テーブル

| カラム | 型 | 説明 |
|--------|-----|------|
| workout_summary_id | references | 紐付くワークアウトサマリー |
| started_at | datetime | 開始時刻 |
| finished_at | datetime | 終了時刻（nullable） |
| total_duration_seconds | integer | 合計時間（秒） |
| average_power | integer | 平均パワー（nullable） |
| max_power | integer | 最大パワー（nullable） |
| average_cadence | integer | 平均ケイデンス（nullable） |
| status | string | completed / abandoned |

### workout_block_results テーブル

| カラム | 型 | 説明 |
|--------|-----|------|
| workout_result_id | references | 紐付くワークアウト結果 |
| workout_block_id | references | 紐付くワークアウトブロック |
| average_power | integer | 平均パワー（nullable） |
| max_power | integer | 最大パワー（nullable） |
| average_cadence | integer | 平均ケイデンス（nullable） |
| duration_seconds | integer | 実績時間（秒） |

### 変更ファイル

- `backend/db/migrate/20250916000001_create_workout_results.rb`
- `backend/db/migrate/20250916000002_create_workout_block_results.rb`

---

## 1-4: バックエンド モデル & API

### モデル

- `WorkoutResult` — バリデーション: started_at必須、total_duration_seconds >= 0、status in [completed, abandoned]
- `WorkoutBlockResult` — バリデーション: duration_seconds >= 0
- `WorkoutSummary` に `has_many :workout_results` を追加

### APIエンドポイント

| メソッド | パス | 説明 |
|---------|------|------|
| GET | `/api/v1/workout_results` | 結果一覧（workout_summary_idでフィルタ可） |
| GET | `/api/v1/workout_results/:id` | 結果詳細（ブロック結果含む） |
| POST | `/api/v1/workout_results` | 結果保存（ブロック結果のネスト送信対応） |

### テスト

- モデルスペック: WorkoutResult（7件）、WorkoutBlockResult（4件）
- リクエストスペック: GET一覧、GETフィルタ、GET詳細、POST作成、POST中断（5件）
- **全40件パス、失敗0件**

### 変更ファイル

- `backend/app/models/workout_result.rb` (新規)
- `backend/app/models/workout_block_result.rb` (新規)
- `backend/app/models/workout_summary.rb` (修正)
- `backend/app/api/entities/workout_result.rb` (新規)
- `backend/app/api/entities/workout_block_result.rb` (新規)
- `backend/app/api/v1/workout_results.rb` (新規)
- `backend/app/api/v1/root.rb` (修正)
- `backend/spec/factories/workout_results.rb` (新規)
- `backend/spec/factories/workout_block_results.rb` (新規)
- `backend/spec/models/workout_result_spec.rb` (新規)
- `backend/spec/models/workout_block_result_spec.rb` (新規)
- `backend/spec/requests/api/v1/workout_results_spec.rb` (新規)

---

## 1-5: フロントエンド 結果送信

### ドメイン層

- `WorkoutResult` モデル（Freezed）
- `WorkoutBlockResult` モデル（Freezed）
- `SaveWorkoutResultUseCase` — 結果をAPIへ保存
- `GetWorkoutResultsUseCase` — 結果一覧を取得

### データ層

- `WorkoutResultDto` / `WorkoutBlockResultDto` — APIレスポンス用DTO
- `SaveWorkoutResultRequest` / `SaveWorkoutBlockResultRequest` — APIリクエスト用
- `WorkoutApiClient` に `getWorkoutResults`、`getWorkoutResult`、`saveWorkoutResult` を追加
- `WorkoutRemoteDataSource` / `WorkoutRepositoryImpl` に対応メソッドを追加

### UI層（WorkoutScreen）

- `WorkoutScreenStateNotifier` がブロックごとのパワー/ケイデンスデータを記録
- ワークアウト完了時に自動で `completed` ステータスで保存
- 停止ボタン押下時に `abandoned` ステータスで保存
- **Flutterテスト20件 全パス**

### 変更ファイル

- `frontend/lib/domain/model/workout/workout_result.dart` (新規)
- `frontend/lib/domain/model/workout/workout_block_result.dart` (新規)
- `frontend/lib/domain/usecase/workout/save_workout_result_use_case.dart` (新規)
- `frontend/lib/domain/usecase/workout/get_workout_results_use_case.dart` (新規)
- `frontend/lib/domain/repository/workout_repository.dart` (修正)
- `frontend/lib/data/remote/model/workout_result_dto.dart` (新規)
- `frontend/lib/data/remote/model/workout_block_result_dto.dart` (新規)
- `frontend/lib/data/remote/model/save_workout_result_request.dart` (新規)
- `frontend/lib/data/remote/model/extensions.dart` (修正)
- `frontend/lib/data/remote/api/workout_api_client.dart` (修正)
- `frontend/lib/data/remote/workout_remote_data_source.dart` (修正)
- `frontend/lib/data/repository/workout_repository_impl.dart` (修正)
- `frontend/lib/di/providers.dart` (修正)
- `frontend/lib/ui/workout/workout_screen_state_notifier.dart` (修正)
- `frontend/lib/ui/workout/workout_screen.dart` (修正)

---

## 1-6: ワークアウト履歴画面

### 新規画面

- `HistoryScreen` — 結果一覧、プルリフレッシュ対応、日時・ステータスバッジ・時間・平均/最大パワー表示
- `WorkoutResultDetailScreen` — 全体サマリー + ブロック別結果の詳細表示
- `HistoryScreenStateNotifier` — 結果一覧の取得・状態管理

### HomeScreen改修

- `ConsumerWidget` → `ConsumerStatefulWidget` に変更
- `BottomNavigationBar` を追加（2タブ: ワークアウト / 履歴）
- `IndexedStack` でタブの状態を保持

### 変更ファイル

- `frontend/lib/ui/history/history_screen.dart` (新規)
- `frontend/lib/ui/history/history_screen_state_notifier.dart` (新規)
- `frontend/lib/ui/history/workout_result_detail_screen.dart` (新規)
- `frontend/lib/ui/home/home_screen.dart` (修正)
