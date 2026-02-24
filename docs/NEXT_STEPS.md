# WorkoutRide 開発 - 次のステップ

## 現在の状況 ✅

**Tier 1 完了** (2026-02-08)
- ✅ workout_results / workout_block_results テーブル・モデル・API
- ✅ フロントエンド：結果保存機能（ワークアウト停止/完了時）
- ✅ フロントエンド：履歴タブ・結果詳細画面
- ✅ RSpecテスト環境構築
- ✅ レート制限（rack-attack）

---

## Tier 2: 認証機能 🔐

### 目的
ユーザーごとにワークアウト結果を管理できるようにする

### バックエンドタスク

#### 2.1 User モデルとDevise設定
- [ ] devise_token_auth gemの追加
- [ ] User モデルの作成
  - email, encrypted_password, tokens（devise_token_auth用）
  - name, created_at, updated_at
- [ ] マイグレーション実行
- [ ] User factory & spec作成

#### 2.2 結果テーブルにuser_id追加
- [ ] workout_results に user_id カラム追加のマイグレーション
- [ ] WorkoutResult / WorkoutBlockResult モデルに belongs_to :user 追加
- [ ] User モデルに has_many :workout_results 追加
- [ ] 既存のFactoryとSpecを更新

#### 2.3 認証APIエンドポイント
- [ ] Grape::API に devise_token_auth をマウント
  - POST /api/v1/auth/sign_in（ログイン）
  - DELETE /api/v1/auth/sign_out（ログアウト）
  - POST /api/v1/auth（ユーザー登録）
  - GET /api/v1/auth/validate_token（トークン検証）
- [ ] 認証ヘルパーメソッドの実装（current_user取得）
- [ ] WorkoutResults APIに認証要求を追加
  - 保存時にcurrent_user.idを自動設定
  - 取得時に自分の結果のみ返す
- [ ] RSpec: 認証フロー・権限チェックのテスト

### フロントエンドタスク

#### 2.4 認証ドメイン層
- [ ] domain/model/user/user.dart（Freezedモデル）
- [ ] domain/repository/auth_repository.dart（インターフェース）
- [ ] domain/usecase/auth/
  - sign_in_use_case.dart
  - sign_out_use_case.dart
  - sign_up_use_case.dart
  - get_current_user_use_case.dart

#### 2.5 認証データ層
- [ ] data/remote/model/user_dto.dart
- [ ] data/remote/model/auth_request.dart / auth_response.dart
- [ ] data/remote/api/auth_api_client.dart（Retrofit）
- [ ] data/remote/auth_remote_data_source.dart
- [ ] data/local/auth_local_data_source.dart（トークン保存：shared_preferences or flutter_secure_storage）
- [ ] data/repository/auth_repository_impl.dart
- [ ] providers.dartに認証関連プロバイダー追加

#### 2.6 認証UI
- [ ] ui/auth/login_screen.dart
- [ ] ui/auth/sign_up_screen.dart
- [ ] ui/auth/auth_state_notifier.dart（ログイン状態管理）
- [ ] main.dartでログイン状態に応じて画面分岐
  - 未ログイン → LoginScreen
  - ログイン済み → HomeScreen
- [ ] ログアウトボタンの追加（HomeScreenまたは設定画面）

#### 2.7 結果保存時の認証統合
- [ ] APIリクエストに認証トークンを自動付与（Interceptor）
- [ ] トークン切れ時の再ログイン処理
- [ ] 履歴画面で自分の結果のみ表示されることを確認

---

## Tier 3: ワークアウト作成・編集機能 + FTP管理 📝

### 目的
ユーザーが独自のワークアウトを作成・編集できるようにする

### バックエンドタスク

#### 3.1 ワークアウト作成・更新API
- [ ] POST /api/v1/workout_summaries（新規作成）
- [ ] PUT /api/v1/workout_summaries/:id（更新）
- [ ] DELETE /api/v1/workout_summaries/:id（削除）
- [ ] ワークアウトにuser_idカラム追加（作成者管理）
- [ ] WorkoutBlock の create/update/delete も一緒に処理（nested attributes）
- [ ] 権限チェック（自分が作成したワークアウトのみ編集可能）
- [ ] バリデーション（名前必須、ブロック順序、時間・パワー範囲など）
- [ ] RSpec: CRUD操作・権限・バリデーションのテスト

#### 3.2 UserFtp モデル
- [ ] user_ftps テーブル作成
  - user_id, ftp_watts, measured_at, notes
- [ ] UserFtp モデル・バリデーション
- [ ] User has_many :user_ftps 関係
- [ ] GET /api/v1/user_ftps（履歴取得）
- [ ] POST /api/v1/user_ftps（FTP記録）
- [ ] GET /api/v1/user_ftps/current（最新FTP取得）
- [ ] Factory & Spec

### フロントエンドタスク

#### 3.3 ワークアウト作成ドメイン層
- [ ] domain/usecase/workout/
  - create_workout_use_case.dart
  - update_workout_use_case.dart
  - delete_workout_use_case.dart
- [ ] domain/repository/workout_repository.dartにメソッド追加

#### 3.4 ワークアウト作成データ層
- [ ] data/remote/model/create_workout_request.dart
- [ ] data/remote/model/update_workout_request.dart
- [ ] workout_api_client.dartにエンドポイント追加
- [ ] workout_remote_data_source.dart & repository_impl更新

#### 3.5 ワークアウト作成UI
- [ ] ui/workout_editor/workout_editor_screen.dart
  - ワークアウト名入力
  - 説明入力
  - ブロックリスト（追加・削除・並び替え）
- [ ] ui/workout_editor/block_editor_dialog.dart
  - ブロックタイプ選択（WARMUP, WORK, REST, COOLDOWN）
  - 時間入力
  - パワー入力（FTP％）
  - ケイデンス入力
- [ ] HomeScreenに「新規ワークアウト作成」ボタン追加
- [ ] ワークアウト詳細画面に「編集」「削除」ボタン追加

#### 3.6 FTP管理機能
- [ ] domain/model/user_ftp.dart
- [ ] domain/usecase/ftp/
  - get_current_ftp_use_case.dart
  - save_ftp_use_case.dart
  - get_ftp_history_use_case.dart
- [ ] data層（DTO, API client, data source, repository）
- [ ] ui/ftp/ftp_settings_screen.dart
  - 現在のFTP表示
  - FTP入力・更新
  - FTP履歴表示（グラフ化も検討）
- [ ] HomeScreenまたは設定画面から遷移

---

## Tier 4: 品質向上・デプロイ準備 🚀

### 4.1 環境設定の整備
- [ ] バックエンド：dotenvでAPIホスト・ポート管理
- [ ] フロントエンド：flutter_dotenv導入
  - .env.development / .env.production
  - API base URLを環境ごとに切り替え
- [ ] .env.exampleファイルの作成

### 4.2 テストカバレッジ向上
- [ ] バックエンド：RSpecカバレッジ80%以上
  - simplecov設定・レポート確認
  - モデル・API・バリデーションの網羅
- [ ] フロントエンド：Widget test・Integration test追加
  - 主要画面のWidget test
  - ログイン〜ワークアウト実行〜結果保存のIntegration test

### 4.3 オフライン対応（オプション）
- [ ] フロントエンド：ローカルDBでワークアウトデータをキャッシュ（sqflite or hive）
- [ ] ネットワーク切断時もワークアウト実行可能に
- [ ] 再接続時に結果を同期アップロード

### 4.4 API ドキュメント
- [ ] Grape Swagger gem導入
- [ ] GET /api/swagger_doc でSwagger UI提供
- [ ] 各エンドポイントにdescription・paramsを追加

### 4.5 デプロイ
- [ ] バックエンド：本番DB設定（Heroku/Render/Fly.io等）
- [ ] バックエンド：CORSヘッダー・SSL設定
- [ ] フロントエンド：iOS/Android ビルド・配布（TestFlightまたはFirebase App Distribution）
- [ ] CI/CD（GitHub Actions）：テスト自動実行

---

## 優先順位

1. **Tier 2（認証）**: 結果をユーザーごとに管理するため必須
2. **Tier 3（ワークアウト作成）**: アプリの価値を大きく高める
3. **Tier 4（品質・デプロイ）**: 実運用に向けた基盤整備

## 推奨スケジュール

- **Tier 2**: 2〜3日（バックエンド1日、フロントエンド1〜2日）
- **Tier 3**: 3〜4日（CRUD API 1日、FTP 0.5日、UI 2日）
- **Tier 4**: 2〜3日（テスト1日、環境設定0.5日、ドキュメント0.5日、デプロイ1日）

**合計**: 約1〜2週間で完成可能

---

## メモ

- Tier 2の認証を実装すれば、マルチユーザー対応の基盤が整う
- Tier 3のワークアウト作成機能で、ユーザー独自のトレーニングプランが可能に
- FTP管理で、パワーゾーンベースのトレーニングがより正確になる
- Tier 4で本番環境にデプロイし、実際のユーザーフィードバックを得られる

---

最終更新: 2026-02-08
