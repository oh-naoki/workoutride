# Tier 2: Google認証基盤 - 実装完了状態

**実装日**: 2026-02-08
**ステータス**: ✅ コード実装完了、GCC設定待ち
**Commits**:
- Backend: `3d49554` - Implement Tier 2: Google Authentication Infrastructure (Backend)
- Frontend: `80acecb` - Implement Tier 2: Google Authentication Infrastructure (Frontend)

---

## 📊 実装サマリー

### Backend実装（完了）

**新規ファイル**:
- `app/models/user.rb` - ユーザーモデル（provider, uid）
- `app/models/auth_token.rb` - 認証トークン管理（30日有効期限）
- `app/models/user_ftp.rb` - ユーザーFTP値
- `app/services/google_auth_service.rb` - Google ID token検証
- `app/api/helpers/auth_helper.rb` - authenticate!, current_user
- `app/api/v1/auth.rb` - 認証API（/auth/google, /auth/logout, /auth/me）
- `db/migrate/*` - users, auth_tokens テーブル、user_id追加

**変更ファイル**:
- `Gemfile` - googleauth, dotenv-rails 追加
- `app/api/v1/root.rb` - Auth API マウント
- `app/api/v1/workout_results.rb` - 認証必須、current_user.workout_results
- `app/api/v1/workouts.rb` - 認証必須
- `app/models/workout_result.rb` - belongs_to :user

**マイグレーション実行済み**: `rails db:migrate`

---

### Frontend実装（完了）

**新規ファイル**:
- `lib/domain/model/auth/user.dart` - Userモデル（id, provider, uid）
- `lib/domain/model/auth/auth_state.dart` - 認証状態
- `lib/domain/repository/auth_repository.dart` - リポジトリインターフェース
- `lib/data/remote/model/auth/user_dto.dart` - DTO
- `lib/data/remote/model/auth/auth_response_dto.dart` - DTO
- `lib/data/remote/api/auth_api_client.dart` - Retrofit APIクライアント
- `lib/data/remote/interceptor/auth_interceptor.dart` - Bearer token自動付与
- `lib/data/repository/auth_repository_impl.dart` - リポジトリ実装
- `lib/ui/auth/login_screen.dart` - ログイン画面
- `lib/ui/auth/auth_state_notifier.dart` - 認証状態管理

**変更ファイル**:
- `pubspec.yaml` - google_sign_in, flutter_secure_storage 追加
- `lib/di/providers.dart` - auth関連provider追加、AuthInterceptor追加
- `lib/main.dart` - 認証ルーティング（LoginScreen/HomeScreen）

**コード生成実行済み**: `dart run build_runner build`

---

## 🏗️ アーキテクチャ決定（D案）

### User モデル: バックエンドデータのみ

```dart
class User {
  final int id;           // バックエンドのuser.id
  final String provider;  // "google"
  final String uid;       // GoogleのユーザーID（sub）
}
```

**理由**:
- ✅ OpenID Connect的に正しい（Google固有情報を持たない）
- ✅ トークンベース認証に最適
- ✅ シンプルで拡張性あり（Apple Sign-In等追加可能）

### GoogleUserInfo: 削除

**理由**:
- Google アカウント情報（email, displayName, photoUrl）は不要
- UIでユーザー名やアバターを表示しない
- トークンさえあればAPIリクエスト可能

---

## 🔐 認証フロー

```
┌─────────┐  1. Sign in   ┌──────────┐  2. ID token  ┌─────────┐
│         │  with Google  │  Google  │  ───────────> │         │
│ Flutter │ ───────────> │  OAuth   │               │ Backend │
│         │               │          │               │         │
└─────────┘               └──────────┘               └─────────┘
     │                                                     │
     │ 3. POST /auth/google { id_token }                  │
     │ ─────────────────────────────────────────────────> │
     │                                                     │
     │                                      4. Verify ID token
     │                                      5. Create/Find User
     │                                      6. Generate AuthToken
     │                                                     │
     │ 7. { token, user: {id, provider, uid} }            │
     │ <───────────────────────────────────────────────── │
     │                                                     │
  8. Store token                                          │
     in SecureStorage                                     │
     │                                                     │
     │ 9. GET /api/v1/workout_summaries                   │
     │    Authorization: Bearer {token}                   │
     │ ─────────────────────────────────────────────────> │
     │                                                     │
     │                                     10. Validate token
     │                                     11. current_user
     │                                                     │
     │ 12. JSON response                                  │
     │ <───────────────────────────────────────────────── │
```

---

## ✅ 動作確認済み

### Backend
```bash
cd backend
rails s
# ✅ サーバー起動OK

curl http://localhost:3000/api/v1/workout_summaries
# ✅ {"error":"Unauthorized"} 返却（認証なしで401）
```

### Frontend
```bash
cd frontend
flutter analyze
# ✅ 59 issues (info/warning のみ、error なし)

flutter run
# ✅ コンパイル成功
# ⏳ ログイン画面表示（Google認証はGCC設定後）
```

---

## ⏳ 次のステップ: Google Cloud Console設定

**必須作業**（詳細は `docs/google-oauth-setup.md` 参照）:

### 1. Google Cloud Console
1. プロジェクト作成: `WorkoutRide`
2. OAuth同意画面設定（外部、テストユーザー追加）
3. iOS Client ID作成（Bundle ID確認）
4. Android Client ID作成（SHA-1取得）

### 2. Backend設定
```bash
# backend/.env.development に追加
GOOGLE_CLIENT_ID=<iOS Client ID>
```

### 3. iOS設定
```xml
<!-- frontend/ios/Runner/Info.plist に追加 -->
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
    </array>
  </dict>
</array>
```

### 4. 実機テスト
```bash
flutter run -d <device>
# 1. Login画面 → Google Sign-In
# 2. 認証成功 → Home画面
# 3. アプリ再起動 → 自動ログイン
```

---

## 📝 開発メモ

### トークン管理
- **保存場所**: `FlutterSecureStorage` (key: `auth_token`)
- **有効期限**: 30日
- **無効化**: ログアウト時にDBから削除

### API認証
- **ヘッダー**: `Authorization: Bearer {token}`
- **自動付与**: `AuthInterceptor` が全リクエストに付与
- **401エラー**: トークン削除（再ログイン必要）

### 既存データ
- **system user**: provider="system", uid="system"
- 既存の workout_results は system user に紐付け済み

---

## 🎯 実装完了後の状態

### Tier 1 ✅
- ワークアウト実行
- 結果保存
- 履歴表示

### Tier 2 ✅ (GCC設定待ち)
- Google認証基盤
- トークンベース認証
- ユーザー管理
- API保護

### Tier 3 ⏳
- ワークアウトCRUD
- UserFtp機能
- FTP設定UI

### Tier 4 ⏳
- 環境設定
- テストカバレッジ
- デプロイ

---

## 🔗 関連ドキュメント

- [Google OAuth セットアップ手順](docs/google-oauth-setup.md)
- [プロジェクトメモリ](~/.claude/projects/-Users-ohnaoki-development-workoutride/memory/MEMORY.md)
- [Tier 2 実装計画](セッションログ参照)

---

## 🚀 次回セッションで実行すること

```bash
# 1. ドキュメント確認
cat docs/google-oauth-setup.md

# 2. GCC設定実施（手順書に従う）

# 3. Backend起動
cd backend && rails s

# 4. Frontend実機テスト
cd frontend && flutter run -d <device>

# 5. 動作確認
# - Google Sign-In成功
# - Home画面遷移
# - 自動ログイン

# 6. 完了後は Tier 3 へ進む
```

---

**作成日**: 2026-02-08
**最終更新**: 2026-02-08
**作成者**: Claude Sonnet 4.5
