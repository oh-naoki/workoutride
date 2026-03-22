# WorkoutRide

WorkoutRideは、サイクリングワークアウトを管理・追跡するためのアプリケーションです。このリポジトリはモノレポ構造を採用しており、フロントエンド（Flutter）とバックエンド（Rails）の両方のコードを含んでいます。

## プロジェクト構造

```
workoutride/
├── frontend/          # Flutterモバイルアプリ
│   ├── android/       # Androidアプリケーション
│   ├── ios/           # iOSアプリケーション
│   ├── lib/           # Dartソースコード
│   └── ...
├── backend/           # Railsバックエンド（開発中）
│   └── ...
└── shared/            # 共有リソース
    ├── models/        # 共通のモデル定義
    ├── api_specs/     # API仕様
    └── docs/          # プロジェクト全体のドキュメント
```

## 開発環境のセットアップ

### フロントエンド（Flutter）

1. Flutterの開発環境をセットアップします（[Flutter公式ドキュメント](https://docs.flutter.dev/get-started/install)）
2. 依存関係をインストールします：
   ```
   cd frontend
   flutter pub get
   ```
3. アプリを実行します：
   ```
   flutter run
   ```

### バックエンド（Rails）

バックエンドは現在開発中です。

## 機能

- パワーメーターデータの表示
- ワークアウトセッションの記録
- BLEデバイスとの接続

## GitHub Actions シークレットの設定

CI/CDパイプラインを正常に動作させるには、GitHubリポジトリに以下のシークレットを登録してください。

シークレットの登録方法: **Settings → Secrets and variables → Actions → New repository secret**

| シークレット名 | 説明 | 用途 |
|---|---|---|
| `FIREBASE_APP_ID` | Firebase コンソールで確認できるアプリID（例: `1:123456789:android:abcdef`） | Firebase App Distribution へのAPKアップロード |
| `FIREBASE_SERVICE_CREDENTIALS` | Firebase サービスアカウントのJSONキー内容 | Firebase App Distribution への認証 |

### FIREBASE_SERVICE_CREDENTIALS の取得手順

1. [Google Cloud Console](https://console.cloud.google.com/) にアクセス
2. 対象プロジェクトを選択 → **IAMと管理 → サービスアカウント**
3. サービスアカウントを作成し、**Firebase App Distribution Admin** ロールを付与
4. サービスアカウントのキーを JSON 形式でダウンロード
5. JSONファイルの内容をそのまま `FIREBASE_SERVICE_CREDENTIALS` シークレットとして登録

> **注意**: シークレットの値は一度登録すると再表示できません。JSONファイルは安全な場所に保管してください。

## 貢献

プロジェクトへの貢献を歓迎します。貢献する前に、以下の点を確認してください：

1. コードスタイルガイドラインに従ってください
2. 適切なテストを追加してください
3. ドキュメントを更新してください

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。
