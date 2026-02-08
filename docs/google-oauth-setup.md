# Google OAuth 2.0 セットアップ手順

**現在の状態**: コード実装完了、Google Cloud Console設定が必要

---

## 前提条件

- Googleアカウント
- Google Cloud Consoleへのアクセス権限
- Backend/Frontend実装完了（コミット済み）

---

## Step 1: Google Cloud Consoleへアクセス

1. [Google Cloud Console](https://console.cloud.google.com/) にアクセス
2. Googleアカウントでログイン

---

## Step 2: プロジェクト作成

1. 画面上部のプロジェクト選択ドロップダウンをクリック
2. 「新しいプロジェクト」をクリック
3. プロジェクト名: `WorkoutRide`（任意）
4. 場所: 組織なしでOK
5. 「作成」をクリック

---

## Step 3: OAuth同意画面の設定

1. 左メニュー → **「APIとサービス」→「OAuth同意画面」**

2. **User Type**: `外部（External）` を選択 → 「作成」

3. **アプリ情報**:
   - アプリ名: `WorkoutRide`
   - ユーザーサポートメール: あなたのGmail
   - アプリのロゴ: スキップ可能

4. **スコープ**: 「保存して次へ」

5. **テストユーザー**:
   - 「+ ADD USERS」
   - 開発に使うGmailアドレスを追加
   - 「保存して次へ」

6. 「ダッシュボードに戻る」

---

## Step 4: iOS Client ID 作成

1. **「APIとサービス」→「認証情報」**
2. **「+ 認証情報を作成」→「OAuth クライアント ID」**

3. **設定**:
   - アプリケーションの種類: `iOS`
   - 名前: `WorkoutRide iOS`
   - バンドルID: `com.example.workoutride`
     ```bash
     # 確認方法（Xcodeで確認）
     open frontend/ios/Runner.xcworkspace
     # Runner → TARGETS → Runner → General → Bundle Identifier
     ```

4. **「作成」をクリック**

5. **Client IDをコピー**:
   ```
   例: 123456789012-abcdefghijklmnopqrstuvwxyz123456.apps.googleusercontent.com
   ```

---

## Step 5: Android Client ID 作成

1. **「+ 認証情報を作成」→「OAuth クライアント ID」**

2. **設定**:
   - アプリケーションの種類: `Android`
   - 名前: `WorkoutRide Android`
   - パッケージ名: `com.example.workoutride`
     ```bash
     # 確認方法
     cat frontend/android/app/build.gradle | grep applicationId
     # 出力: applicationId "com.example.workoutride"
     ```

3. **SHA-1フィンガープリント取得**:
   ```bash
   cd frontend/android
   ./gradlew signingReport
   ```

   出力から SHA-1 をコピー:
   ```
   Variant: debug
   SHA1: A1:B2:C3:D4:E5:F6:G7:H8:I9:J0:K1:L2:M3:N4:O5:P6:Q7:R8:S9:T0
   ```

4. **SHA-1を入力** → 「作成」

---

## Step 6: Backend設定

### 6-1. 環境変数設定

`backend/.env.development` を編集:

```bash
# iOS Client IDを設定（Androidではない！）
GOOGLE_CLIENT_ID=123456789012-abcdefghijklmnopqrstuvwxyz123456.apps.googleusercontent.com
```

### 6-2. Backend起動確認

```bash
cd backend
rails s

# 別ターミナルでテスト
curl http://localhost:3000/api/v1/workout_summaries
# 期待: {"error":"Unauthorized"}
```

---

## Step 7: iOS設定

### 7-1. Info.plist 編集

`frontend/ios/Runner/Info.plist` に追加:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <!-- iOSクライアントIDを逆順にしたもの -->
      <string>com.googleusercontent.apps.123456789012-abcdefghijklmnopqrstuvwxyz123456</string>
    </array>
  </dict>
</array>
```

**URL Schemeの作り方**:
- 元: `123456789012-abc...xyz.apps.googleusercontent.com`
- 逆順: `com.googleusercontent.apps.123456789012-abc...xyz`

### 7-2. CocoaPods インストール

```bash
cd frontend/ios
pod install
```

---

## Step 8: Android設定

### 8-1. SHA-1が正しく登録されているか確認

Google Cloud Console → 認証情報 → Android Client ID → SHA-1を確認

### 8-2. Google Play Services確認

`frontend/android/app/build.gradle` に以下があることを確認:

```gradle
dependencies {
    implementation 'com.google.android.gms:play-services-auth:20.7.0'
}
```

なければ追加してsyncする。

---

## Step 9: 実機テスト

### 9-1. iOS

```bash
cd frontend
flutter run -d <iOSデバイスID>

# デバイスIDの確認
flutter devices
```

### 9-2. Android

```bash
flutter run -d <AndroidデバイスID>
```

### 9-3. テスト手順

1. アプリ起動 → LoginScreen表示確認
2. 「Sign in with Google」タップ
3. Google認証画面表示
4. アカウント選択
5. ログイン成功 → HomeScreen表示
6. アプリ再起動 → 自動ログイン（HomeScreen直行）

---

## トラブルシューティング

### エラー: PlatformException(sign_in_failed)

**原因**: Google Cloud Consoleの設定ミス

**確認事項**:
1. Bundle ID / パッケージ名が一致しているか
2. SHA-1が正しく登録されているか
3. テストユーザーに自分のGmailが追加されているか
4. OAuth同意画面が「テスト」状態か

### エラー: このアプリは確認されていません

**原因**: OAuth同意画面が「外部」で公開されていない

**解決**: テストユーザーに自分のGmailアドレスを追加

### iOS: URL Schemeエラー

**原因**: Info.plistの設定ミス

**確認**: Client IDが逆順になっているか確認

### Android: SHA-1が取得できない

```bash
# 方法1: Gradle
cd frontend/android
./gradlew signingReport

# 方法2: keytool
keytool -list -v -alias androiddebugkey \
  -keystore ~/.android/debug.keystore \
  -storepass android -keypass android
```

---

## 完了確認

以下が動作すればOK:

- ✅ ログイン画面でGoogle認証が動作
- ✅ 認証後HomeScreen表示
- ✅ アプリ再起動で自動ログイン
- ✅ ログアウトボタンでログイン画面に戻る（実装次第）

---

## 次のステップ

GCC設定が完了したら:

1. Tier 3に進む（ワークアウトCRUD、UserFtp）
2. または追加機能の実装

---

## 参考リンク

- [Google Cloud Console](https://console.cloud.google.com/)
- [google_sign_in package](https://pub.dev/packages/google_sign_in)
- [Google OAuth 2.0 Documentation](https://developers.google.com/identity/protocols/oauth2)
