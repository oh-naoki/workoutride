# 次回セッション クイックスタート

**前回の状態**: GCC設定途中、Android実機テスト未完了
**次のタスク**: Android実機テスト → 動作確認 → コミット

---

## 今回のセッションで完了したこと

### Google Cloud Console 設定 (完了)
- [x] GCPプロジェクト `WorkoutRide` 作成
- [x] OAuth同意画面設定（外部、テストユーザー追加済み）
- [x] iOS Client ID 作成
- [x] Android Client ID 作成 (SHA-1登録済み)
- [x] Web Client ID 作成 (serverClientId / Backend検証用)

### Client ID 一覧
| 種類 | Client ID |
|------|-----------|
| iOS | `286301513915-3pm1uigk28ph9kkkdvpdv401qjudld81.apps.googleusercontent.com` |
| Android | `286301513915-6mg9p8mcan9iegf8llrdmsai0vqbnf6k.apps.googleusercontent.com` |
| Web | `286301513915-c78mhj94noqq6ro5jr3hba5983df2vhs.apps.googleusercontent.com` |

### コード修正 (未コミット)
1. **`backend/.env.development`** — `GOOGLE_CLIENT_ID` を Web Client ID に設定
2. **`frontend/ios/Runner/Info.plist`** — iOS URL Scheme 追加 (CFBundleURLTypes)
3. **`frontend/lib/di/providers.dart`** — `GoogleSignIn` に `serverClientId` (Web Client ID) 追加
4. **`frontend/lib/ui/auth/auth_state_notifier.dart`** — エラー握りつぶしバグ修正（エラーが画面に表示されるように）

### openjdk インストール済み
- `brew install openjdk` 実行済み（SHA-1取得のため）
- パス: `/opt/homebrew/opt/openjdk/bin`

---

## 次回やること

### 1. Android 実機テスト (最優先)

```bash
# Backend 起動
cd /Users/ohnaoki/development/workoutride/backend
rails s -b 0.0.0.0

# 別ターミナルで Flutter 実行
cd /Users/ohnaoki/development/workoutride/frontend
flutter run -d adb-37271FDJH00AW3-qYdn8m._adb-tls-connect._tcp
# ※ デバイスIDは `flutter devices` で再確認
```

### 2. テスト手順

1. アプリ起動 → LoginScreen 表示確認
2. 「Sign in with Google」タップ
3. Google 認証画面 → アカウント選択
4. ログイン成功 → HomeScreen 表示
5. アプリ再起動 → 自動ログイン確認

### 3. エラーが出た場合

前回の症状: アカウント選択後に画面遷移しない → エラー表示修正済みなので、次回はエラーメッセージが表示されるはず

**よくある原因**:
- Backend が起動していない / Pixel から到達できない
- API base URL (`192.168.0.214:3000`) が現在のIPと違う → `workout_api_client.dart` と `auth_api_client.dart` を確認
- Web Client ID の不一致

### 4. 成功したらコミット

```
git add backend/.env.development frontend/ios/Runner/Info.plist \
  frontend/lib/di/providers.dart frontend/lib/ui/auth/auth_state_notifier.dart
git commit -m "Configure Google OAuth credentials and fix auth error handling"
```

### 5. その後 → Tier 3 へ

- ワークアウト CRUD API + 作成UI
- UserFtp 機能

---

## 変更済みファイル (未コミット)

```
modified: backend/.env.development
modified: frontend/ios/Runner/Info.plist
modified: frontend/lib/di/providers.dart
modified: frontend/lib/ui/auth/auth_state_notifier.dart
```

---

## 重要な注意

- **Backend の `GOOGLE_CLIENT_ID`**: Web Client ID を使う（iOS/Android 両方の ID トークンの `aud` が Web Client ID になるため）
- **`serverClientId`**: Android で ID トークンを取得するために必須。iOS でも同じ Web Client ID を使えば Backend と `aud` が一致する
- **API base URL**: `192.168.0.214:3000` にハードコード中。自宅のIPが変わった場合は要変更

---

**作成日**: 2026-02-08
**このファイルは次回セッション開始時に読んでください**
