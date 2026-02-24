# WorkoutRide プロジェクト状況整理 & 開発優先順位

## 現在のプロジェクト状況

### 概要
サイクリングワークアウト管理アプリ。Flutter(モバイル) + Rails(API)のモノレポ構成。
BLEパワーメーターと連携し、FTPベースのトレーニングゾーンでワークアウトを実行できる。
**複数ユーザー利用を想定。**

---

### バックエンド (Rails 8.0.2 + Grape API)

| 項目 | 状態 |
|------|------|
| モデル | WorkoutSummary, WorkoutBlock の2つ。UserFtpはテーブルのみ(モデルファイルなし) |
| API | **読み取り専用** — `GET /workout_summaries`, `GET /workout_blocks/:id` のみ |
| 認証 | **なし** |
| レート制限 | rack-attack で 100req/min |
| テスト | RSpec — モデル・APIリクエストテスト有り(未コミット) |
| DB | PostgreSQL、マイグレーション8件全適用済み |
| シードデータ | 10種のZwift系ワークアウトメニュー。**ただしseeds.rbは旧スキーマ(workoutsテーブル経由)を参照しており壊れている** |
| デプロイ | Kamal + Docker設定はあるが未デプロイ |

### フロントエンド (Flutter/Dart)

| 項目 | 状態 |
|------|------|
| 画面 | Home, WorkoutDetail, Workout, Settings, BLE Scan の5画面 |
| BLE連携 | パワーメーター接続・データ読取・3秒平均・自動再接続 — **実装済み** |
| ワークアウト実行 | カウントダウン・一時停止/再開・ブロック進行・パワーアラート — **実装済み** |
| ユーザー設定 | 体重・FTP登録(ローカルストレージ) — **実装済み** |
| 状態管理 | Riverpod + RxDart — **実装済み** |
| テスト | UseCase・StateNotifier のユニットテスト有り |
| API通信 | Retrofit/Dio、ベースURL **ハードコード**(192.168.0.214:3000) |

---

### 未実装・不完全な機能一覧

| # | 項目 | 影響範囲 | 状態 |
|---|------|----------|------|
| 1 | ワークアウト実行結果の記録 | API + フロント | **Tier 1 で実装済み** |
| 2 | ワークアウトCRUD API (作成/更新/削除) | API | 未実装 |
| 3 | ユーザー認証 | API + フロント | 未実装 |
| 4 | ワークアウト作成/編集UI | フロント | 未実装 |
| 5 | UserFtpモデルファイル未作成(テーブルのみ) | API | 未実装 |
| 6 | 停止ボタン — 確認ダイアログのみ、結果保存なし | フロント | **Tier 1 で実装済み** |
| 7 | ワークアウト履歴画面 | フロント | **Tier 1 で実装済み** |
| 8 | seeds.rb が旧スキーマで壊れている | API | **Tier 1 で修正済み** |
| 9 | オフライン対応 | フロント | 未実装 |
| 10 | APIベースURLハードコード | フロント | 未実装 |
| 11 | API仕様書 (shared/api_specs/ 空) | ドキュメント | 未実装 |

---

## 開発優先順位

### Tier 1: ワークアウト結果記録（縦断で一気通貫）— 実装済み

ワークアウトを実行して結果が残る、という最も基本的なフローを完成させる。

| # | タスク | 詳細 | 状態 |
|---|--------|------|------|
| 1-1 | **seeds.rb 修正** | 旧スキーマ(workouts経由)→新スキーマ(WorkoutSummary直下にBlocks)に更新。開発環境のデータ投入を復旧 | 完了 |
| 1-2 | **workout_results テーブル設計・作成** | マイグレーション追加。カラム: workout_summary_id, started_at, finished_at, total_duration_seconds, average_power, max_power, average_cadence, status(completed/abandoned) | 完了 |
| 1-3 | **workout_block_results テーブル設計・作成** | ブロックごとの実績。カラム: workout_result_id, workout_block_id, average_power, max_power, average_cadence, duration_seconds | 完了 |
| 1-4 | **モデル・API追加** | WorkoutResult, WorkoutBlockResult モデル。`POST /workout_results` で結果保存。`GET /workout_results` で履歴取得 | 完了 |
| 1-5 | **フロント: 結果送信** | ワークアウト完了/停止時に実行結果をAPIに送信。WorkoutScreenのstopボタン完成 | 完了 |
| 1-6 | **フロント: 履歴画面** | HomeScreenに履歴タブまたは一覧表示を追加。結果の詳細表示 | 完了 |

### Tier 2: 認証 & ユーザー管理

複数ユーザー対応のために必要。

| # | タスク | 詳細 | 状態 |
|---|--------|------|------|
| 2-1 | ユーザーモデル・認証API | User モデル、devise_token_auth 等でトークン認証 | 未実装 |
| 2-2 | 既存モデルにuser_id追加 | WorkoutResult, UserFtp にユーザー紐付け | 未実装 |
| 2-3 | フロント: ログイン/登録画面 | 認証フロー実装 | 未実装 |
| 2-4 | API認証ガード | 全エンドポイントに認証必須化 | 未実装 |

### Tier 3: ワークアウト管理の充実

| # | タスク | 詳細 | 状態 |
|---|--------|------|------|
| 3-1 | ワークアウトCRUD API | POST/PUT/DELETE エンドポイント | 未実装 |
| 3-2 | ワークアウト作成/編集UI | ブロック構成を含むワークアウト作成画面 | 未実装 |
| 3-3 | UserFtpモデル整備・API化 | FTPのバックエンド管理に切替え | 未実装 |

### Tier 4: 品質・運用

| # | タスク | 詳細 | 状態 |
|---|--------|------|------|
| 4-1 | 環境設定の外部化 | APIベースURLを環境変数/flavor化 | 未実装 |
| 4-2 | テストカバレッジ拡充 | ManageWorkoutUseCase、BLE、ウィジェットテスト | 未実装 |
| 4-3 | バックエンドデプロイ | Kamal での本番デプロイ | 未実装 |
| 4-4 | オフライン対応 | ローカルDB、同期機能 | 未実装 |
| 4-5 | API仕様書整備 | OpenAPI/Swagger | 未実装 |
