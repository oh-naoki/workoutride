# 🚀 次回セッション クイックスタート

**前回の状態**: Tier 2 実装完了（コード完成、GCC設定待ち）
**次のタスク**: Google Cloud Console設定 → 実機テスト

---

## 📋 3ステップで再開

### Step 1: 状態確認（1分）

```bash
cd /Users/ohnaoki/development/workoutride

# 最新のコミット確認
git log --oneline -3

# 期待する出力:
# 01e4fc6 Add Tier 2 documentation and status summary
# 80acecb Implement Tier 2: Google Authentication Infrastructure (Frontend)
# 3d49554 Implement Tier 2: Google Authentication Infrastructure (Backend)

# ドキュメント確認
ls docs/
# 期待: google-oauth-setup.md

ls TIER2_STATUS.md
# 期待: TIER2_STATUS.md
```

### Step 2: ドキュメント読む（5分）

```bash
# 詳細な手順書
cat docs/google-oauth-setup.md

# 実装状況サマリー
cat TIER2_STATUS.md

# プロジェクトメモリ
cat ~/.claude/projects/-Users-ohnaoki-development-workoutride/memory/MEMORY.md
```

### Step 3: Google Cloud Console設定開始（30-60分）

手順書に従って実施: `docs/google-oauth-setup.md`

---

## ⚡ 超クイック再開（既に手順を知っている場合）

### 必須タスク

1. **Google Cloud Console**
   - [https://console.cloud.google.com/](https://console.cloud.google.com/)
   - プロジェクト作成 → OAuth設定 → iOS/Android Client ID作成

2. **Backend設定**
   ```bash
   # backend/.env.development 編集
   GOOGLE_CLIENT_ID=<iOS Client ID>
   ```

3. **iOS設定**
   ```bash
   # frontend/ios/Runner/Info.plist に URL Scheme追加
   # 詳細は docs/google-oauth-setup.md 参照
   ```

4. **テスト**
   ```bash
   # Backend起動
   cd backend && rails s

   # Frontend実機起動（別ターミナル）
   cd frontend && flutter run
   ```

---

## 🎯 期待する結果

### テスト成功の条件

- ✅ ログイン画面でGoogle Sign-In動作
- ✅ 認証成功後HomeScreen表示
- ✅ アプリ再起動で自動ログイン
- ✅ バックエンドが401を返さない

### テスト失敗時

`docs/google-oauth-setup.md` のトラブルシューティングを参照

---

## 📝 前回のセッション概要

### 実装内容

**Backend** (commit: 3d49554):
- User, AuthToken モデル
- Google ID token検証サービス
- Auth API (POST /auth/google, DELETE /auth/logout, GET /auth/me)
- 全APIに認証追加

**Frontend** (commit: 80acecb):
- User model (id, provider, uid)
- AuthRepository + GoogleSignIn統合
- AuthInterceptor (Bearer token自動付与)
- LoginScreen
- 認証状態管理

### アーキテクチャ決定

- **D案採用**: User は id, provider, uid のみ
- **GoogleUserInfo 削除**: OpenID Connect的に正しい設計
- **トークンベース認証**: シンプルで高速

---

## 🔗 重要なファイル

### ドキュメント
- `docs/google-oauth-setup.md` - OAuth設定手順（最重要）
- `TIER2_STATUS.md` - 実装完了状況
- `memory/MEMORY.md` - プロジェクト全体の記録

### Backend
- `backend/.env.development.example` - 環境変数テンプレート
- `backend/app/api/v1/auth.rb` - 認証API
- `backend/app/models/user.rb`, `auth_token.rb` - モデル

### Frontend
- `frontend/lib/ui/auth/login_screen.dart` - ログイン画面
- `frontend/lib/data/repository/auth_repository_impl.dart` - 認証ロジック
- `frontend/lib/di/providers.dart` - DI設定

---

## 💡 次回セッションで聞くこと

Claude Codeに次のように伝えればOK:

```
「Tier 2の続きです。Google Cloud Consoleの設定をしたいです。」

または

「TIER2_STATUS.mdとgoogle-oauth-setup.mdを読んで、
次のステップを教えてください。」
```

---

## ⚠️ 注意事項

### GCC設定時

- **Client ID**: iOSとAndroidで別々に作成
- **Backend**: iOSのClient IDを使用
- **SHA-1**: Androidは必須、デバッグ用も登録
- **テストユーザー**: 自分のGmailアドレスを必ず追加

### 実機テスト

- **エミュレータでは動作しない可能性あり**
- **実機またはシミュレータで確認**
- **初回は必ずGoogle認証画面が表示される**

---

## 🎉 完了後

GCC設定が完了し、実機テストが成功したら:

### オプション A: Tier 3 に進む
- ワークアウトCRUD API
- UserFtp機能
- FTP設定UI

### オプション B: 認証機能を拡張
- ログアウトボタン追加
- プロフィール画面
- ユーザー情報表示

---

**作成日**: 2026-02-08
**このファイルは次回セッション開始時に読んでください**
