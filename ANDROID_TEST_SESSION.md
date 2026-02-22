# Android実機テスト セッション記録

**日時**: 2026-02-22
**目的**: Google認証を含むAndroid実機テストの実施

---

## 実施した修正

### 1. API Base URL更新
**問題**: ハードコードされたIPアドレスが古い（192.168.0.214 → 192.168.0.168）

**修正ファイル**:
- `frontend/lib/data/remote/api/workout_api_client.dart`
- `frontend/lib/data/remote/api/auth_api_client.dart`

**変更内容**:
```dart
@RestApi(baseUrl: "http://192.168.0.168:3000/api/v1")
```

### 2. AuthHelper読み込みエラー解決
**エラー**: `NameError (uninitialized constant Grape::API::Helpers::AuthHelper)`

**根本原因**:
- Grape::APIクラス内で`helpers Helpers::AuthHelper`を使用すると、Railsのautoloadが`Grape::API::Helpers::AuthHelper`として名前解決しようとする
- 実際のモジュールは`::Helpers::AuthHelper`（トップレベル）に存在

**修正内容**:
1. `config/application.rb`にautoload設定追加:
```ruby
config.eager_load_paths << Rails.root.join("app/api")
config.autoload_paths << Rails.root.join("app/api")
```

2. 3つのAPIファイルで`helpers`を`include`に変更し、トップレベルから参照:
   - `app/api/v1/auth.rb`
   - `app/api/v1/workouts.rb`
   - `app/api/v1/workout_results.rb`

```ruby
# Before
helpers Helpers::AuthHelper

# After
include ::Helpers::AuthHelper
```

### 3. GoogleAuthService API修正
**エラー**: `NoMethodError (undefined method 'verifier' for module Google::Auth::IDTokens)`

**根本原因**:
- googleauth gem (1.16.1) の正しいAPIは`verify_oidc`メソッド
- `verifier`や`http_verifier`メソッドは存在しない

**修正内容** (`app/services/google_auth_service.rb`):
```ruby
# Before
def verify_token
  verifier = Google::Auth::IDTokens.verifier
  verifier.verify(@id_token, aud: GOOGLE_CLIENT_ID)
end

# After
def verify_token
  Google::Auth::IDTokens.verify_oidc(@id_token, aud: GOOGLE_CLIENT_ID)
end
```

---

## 現在の状態

### Backend (Rails)
- ✅ AuthHelperエラー解決済み
- ✅ GoogleAuthService API修正済み
- ✅ Rails server起動中 (http://0.0.0.0:3000)
- ⏳ 最新コード反映待ち（再起動完了待ち）

### Frontend (Flutter)
- ✅ API base URL更新済み
- ✅ build_runner実行済み
- ⏳ Pixel 8へのインストール中（無線接続のため時間がかかる）

### 未コミット変更
```
modified: backend/config/application.rb
modified: backend/app/api/v1/auth.rb
modified: backend/app/api/v1/workouts.rb
modified: backend/app/api/v1/workout_results.rb
modified: backend/app/services/google_auth_service.rb
modified: frontend/lib/data/remote/api/workout_api_client.dart
modified: frontend/lib/data/remote/api/auth_api_client.dart
```

---

## 次のステップ

### 1. Rails server起動確認
```bash
tail -30 /private/tmp/claude-501/-Users-ohnaoki-development-workoutride/tasks/bb09611.output
```
期待する出力: `* Listening on http://0.0.0.0:3000`

### 2. Flutterアプリインストール完了待ち
```bash
tail -30 /private/tmp/claude-501/-Users-ohnaoki-development-workoutride/tasks/b8fccaf.output
```
期待する出力: `Flutter run key commands.` または `Syncing files to device`

### 3. Android実機でログインテスト
1. Pixel 8で「Sign in with Google」ボタンをタップ
2. Googleアカウントを選択
3. 結果確認:
   - ✅ **成功**: HomeScreen表示
   - ❌ **失敗**: エラーメッセージを確認

### 4. ログ確認
ログイン試行後、Railsサーバーログを確認:
```bash
tail -50 /private/tmp/claude-501/-Users-ohnaoki-development-workoutride/tasks/bb09611.output
```

**期待する成功ログ**:
```
Started POST "/api/v1/auth/google" for 192.168.0.151 at ...
Completed 200 OK
```

**エラーの場合**:
- NoMethodError, NameError → コード修正が必要
- 401/403 → 認証エラー（Google Client ID設定確認）
- 500 → サーバーエラー（スタックトレース確認）

### 5. 成功したらコミット
```bash
cd /Users/ohnaoki/development/workoutride

# Backend変更
git add backend/config/application.rb \
  backend/app/api/v1/auth.rb \
  backend/app/api/v1/workouts.rb \
  backend/app/api/v1/workout_results.rb \
  backend/app/services/google_auth_service.rb

# Frontend変更
git add frontend/lib/data/remote/api/workout_api_client.dart \
  frontend/lib/data/remote/api/auth_api_client.dart

git commit -m "Fix Google authentication and API issues

- Fix AuthHelper autoload in Grape API (use ::Helpers::AuthHelper)
- Fix GoogleAuthService to use correct verify_oidc API
- Update API base URL to current IP (192.168.0.168)
- Add eager_load_paths configuration for API modules

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## トラブルシューティング

### Google認証エラーが出る場合

#### Backend GOOGLE_CLIENT_ID確認
```bash
cat backend/.env.development | grep GOOGLE_CLIENT_ID
```
期待値: Web Client ID (`286301513915-c78mhj94noqq6ro5jr3hba5983df2vhs.apps.googleusercontent.com`)

#### Frontend serverClientId確認
```bash
grep -A 5 "GoogleSignIn" frontend/lib/di/providers.dart
```
期待値: Web Client IDが`serverClientId`に設定されている

#### SHA-1フィンガープリント確認
Google Cloud Consoleで、Android Client IDに正しいSHA-1が登録されているか確認

### API接続エラーが出る場合

#### IP確認
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1 | head -1
```
現在のIPアドレスを確認して、APIクライアントのbase URLと一致するか確認

#### Backend到達確認
```bash
curl -s http://192.168.0.168:3000/api/v1/auth/google -X POST -H "Content-Type: application/json" -d '{"id_token":"test"}'
```
404でない応答（500やエラーメッセージ）が返ればBackendに到達している

---

## 備考

### google-services.json (未対応)
Android向けGoogle Sign-InにはFirebaseの`google-services.json`が必要だが、現在は未配置。
もし"no host error"が再発する場合は、Firebase Console設定が必要。

詳細は`QUICKSTART_NEXT_SESSION.md`参照。

---

**次回セッション**: ログイン成功後、Tier 3（Workout CRUD API + 作成UI, UserFtp機能）に進む
