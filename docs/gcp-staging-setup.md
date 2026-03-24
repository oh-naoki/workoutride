# GCP Staging 環境構築ドキュメント

作成日: 2026-03-24

## サーバー構成図

```
┌─────────────────────────────────────────────────────────────────────┐
│  GitHub                                                             │
│  ┌───────────────┐    push to main    ┌──────────────────────────┐  │
│  │  Repository    │──────────────────▶│  GitHub Actions          │  │
│  │  oh-naoki/     │                   │  deploy-staging.yml      │  │
│  │  workoutride   │                   │                          │  │
│  └───────────────┘                   │  1. Build Docker image   │  │
│                                       │  2. Push to Artifact Reg │  │
│                                       │  3. kamal deploy via SSH │  │
│                                       └──────┬───────────────────┘  │
└──────────────────────────────────────────────┼──────────────────────┘
                                               │
                    SSH (port 22)               │  Docker push
                    + kamal deploy              │
                                               │
┌──────────────────────────────────────────────┼──────────────────────┐
│  GCP Project: workoutride-app                │                      │
│                                              │                      │
│  ┌───────────────────────────────────────────┼──────────────────┐   │
│  │  Artifact Registry (us-east1)             │                  │   │
│  │  workoutride-staging/backend    ◀─────────┘                  │   │
│  │  (Docker images)                                             │   │
│  └──────────────────────────┬───────────────────────────────────┘   │
│                             │ docker pull                           │
│                             ▼                                       │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  Compute Engine: workoutride-staging (e2-micro, us-east1-b) │   │
│  │  External IP: 34.138.232.78 (静的IP)                         │   │
│  │  Internal IP: 10.142.0.2                                     │   │
│  │  Disk: 20GB (pd-balanced)                                    │   │
│  │  OS: Debian 13 (Trixie)                                      │   │
│  │                                                              │   │
│  │  ┌────────────────────────────────────────────────────────┐  │   │
│  │  │  Docker                                                │  │   │
│  │  │                                                        │  │   │
│  │  │  ┌──────────────┐    ┌─────────────────────────────┐   │  │   │
│  │  │  │ kamal-proxy  │    │ backend-web                 │   │  │   │
│  │  │  │              │    │ (Rails 8 + Puma + SolidQueue)│  │  │   │
│  │  │  │ :443 ──TLS──▶│:80│──▶ :3000                     │   │  │   │
│  │  │  │ :80          │    │                              │   │  │   │
│  │  │  └──────────────┘    └──────────┬──────────────────┘   │  │   │
│  │  │                                 │                      │  │   │
│  │  └─────────────────────────────────┼──────────────────────┘  │   │
│  └────────────────────────────────────┼─────────────────────────┘   │
│                                       │ PostgreSQL (port 5432)      │
│                                       │ VPC Private IP              │
│                                       ▼                             │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  Cloud SQL: workoutride-staging                              │   │
│  │  PostgreSQL 16 / db-custom-1-3840                            │   │
│  │  Private IP: 10.106.144.3                                    │   │
│  │                                                              │   │
│  │  DBs: backend_production, backend_production_cache,          │   │
│  │       backend_production_queue, backend_production_cable      │   │
│  │  User: backend                                               │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  Secret Manager                                              │   │
│  │  - RAILS_MASTER_KEY                                          │   │
│  │  - BACKEND_DATABASE_PASSWORD                                 │   │
│  │  - GCP_SA_KEY (サービスアカウントキー)                           │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  URL: https://34.138.232.78.nip.io                                 │
│  Health Check: https://34.138.232.78.nip.io/up                     │
│  API: https://34.138.232.78.nip.io/api/v1/...                      │
└─────────────────────────────────────────────────────────────────────┘
```

## デプロイフロー

```
git push main
    │
    ▼
GitHub Actions (deploy-staging.yml)
    │
    ├─ 1. actions/checkout
    ├─ 2. ruby/setup-ruby (3.4.1 + bundler cache)
    ├─ 3. google-github-actions/auth (SA Key JSON)
    ├─ 4. gcloud auth configure-docker (Artifact Registry)
    ├─ 5. SSH key setup (workoutride_deploy)
    └─ 6. bundle exec kamal deploy
           │
           ├─ .kamal/secrets で gcloud から秘密情報取得
           │   ├─ KAMAL_REGISTRY_PASSWORD ← gcloud auth print-access-token
           │   ├─ RAILS_MASTER_KEY ← Secret Manager
           │   └─ BACKEND_DATABASE_PASSWORD ← Secret Manager
           │
           ├─ Docker buildx (GitHub Actions runner, amd64)
           │   └─ Push to Artifact Registry
           │
           ├─ SSH で VM にデプロイ
           │   ├─ docker pull (新イメージ)
           │   ├─ docker run (新コンテナ起動)
           │   │   └─ entrypoint: db:prepare → puma server
           │   └─ kamal-proxy: /up ヘルスチェック → TLS 切り替え
           │
           └─ 完了
```

## 構築で解決した問題一覧

### 1. `.kamal/secrets` の `${VAR:-...}` 構文が非対応
- **症状**: env var の値に `:-value}` がリテラルとして入った
- **原因**: Kamal は `$(...)` コマンド置換は評価するが、bash のパラメータ展開 `${VAR:-default}` は非対応
- **修正**: `${VAR:-$(gcloud ...)}` → `$(gcloud ...)` に変更

### 2. `DATABASE_URL` が multi-DB 構成で壊れる
- **症状**: `URI::InvalidURIError: bad URI`
- **原因**: `database.yml` が multi-DB（primary/cache/queue/cable）構成で、`DATABASE_URL` を全 DB に適用しようとして失敗。さらにパスワードの `@!` が URI パーサーを混乱させた
- **修正**: `DATABASE_URL` を廃止。`BACKEND_DATABASE_PASSWORD` + `DB_HOST` の個別 env var に変更

### 3. Docker コンテナから Cloud SQL に到達不能
- **症状**: `db:prepare` が無限ハング（タイムアウトまで何も出力なし）
- **原因**: VM のカーネル IP forwarding が無効（`net.ipv4.ip_forward = 0`）。Docker bridge ネットワークから VPC private IP にパケットが転送されなかった
- **修正**: `echo 1 > /proc/sys/net/ipv4/ip_forward` + `/etc/sysctl.conf` に永続化

### 4. Cloud SQL が暗号化接続のみ許可
- **症状**: `pg_hba.conf rejects connection ... no encryption`
- **原因**: Cloud SQL のデフォルト SSL モードが `ENCRYPTED_ONLY`
- **修正**: `gcloud sql instances patch --ssl-mode=ALLOW_UNENCRYPTED_AND_ENCRYPTED`

### 5. パスワードの特殊文字（`@!`）が各所で問題
- **症状**: URL エンコード後も URI パーサーエラー、Kamal 経由の env 渡しで化ける可能性
- **原因**: `Oh@!19910819` の `@` と `!` がシェル展開・URI パース・Docker env file で問題を起こす
- **修正**: パスワードを `WorkoutRide2024-db`（特殊文字 `-` のみ）に変更

### 6. `deploy_timeout` の配置場所が間違い
- **症状**: `proxy: unknown key: deploy_timeout`
- **原因**: Kamal 2 では `deploy_timeout` は `proxy` セクション配下ではなくトップレベル設定
- **修正**: `proxy.deploy_timeout` → トップレベルの `deploy_timeout: 120` に移動

### 7. `/up` ヘルスチェックルートが未定義
- **症状**: `ActionController::RoutingError (No route matches [GET] "/up")`（404）
- **原因**: Grape API アプリなので Rails デフォルトの `/up` ルートが自動設定されない
- **修正**: `routes.rb` に `get "up" => "rails/health#show"` を追加

### 8. ディスク容量不足（10GB）
- **症状**: `error saving credentials: no space left on device`、`mkdir` 失敗で deploy lock エラー
- **原因**: e2-micro のデフォルト 10GB ディスクに Docker イメージ（各約 1GB）が蓄積
- **修正**: `gcloud compute disks resize` で 20GB に拡張 + `growpart` + `resize2fs`

### 9. Docker buildx のクロスコンパイル問題（arm64 → amd64）
- **症状**: `prism` gem のネイティブ拡張ビルドが失敗
- **原因**: Mac（arm64）からamd64 イメージをビルドする際のクロスコンパイル問題
- **修正**: GitHub Actions の ubuntu runner（amd64 ネイティブ）でビルドする方式に変更

### 10. VM の IP アドレスが再起動で変わる
- **症状**: デプロイ先 IP が変わってしまう
- **原因**: エフェメラル IP を使っていた
- **修正**: 静的 IP `workoutride-staging-ip`（34.138.232.78）を予約して割り当て

### 11. macOS Docker credential store が SSH 経由で使えない
- **症状**: `docker-credential-osxkeychain: credentials not found`
- **原因**: SSH セッションから macOS Keychain にアクセスできない
- **修正**: Colima に移行、`~/.docker/config.json` から `credsStore: desktop` を削除

## GCP リソース一覧

| リソース | 名前 | スペック | 備考 |
|---|---|---|---|
| VM | workoutride-staging | e2-micro, us-east1-b, 20GB disk | Debian 13, Docker + Colima |
| 静的 IP | workoutride-staging-ip | 34.138.232.78 | VM に割り当て済み |
| Cloud SQL | workoutride-staging | PostgreSQL 16, db-custom-1-3840 | Private IP: 10.106.144.3 |
| Cloud SQL | workoutride-production | PostgreSQL 18, db-custom-1-3840 | Private IP: 10.106.144.5（未使用）|
| Artifact Registry | workoutride-staging | Docker | イメージ格納先 |
| Artifact Registry | workoutride-production | Docker | 空（未使用）|
| Secret Manager | RAILS_MASTER_KEY | - | Rails マスターキー |
| Secret Manager | BACKEND_DATABASE_PASSWORD | - | DB パスワード |
| Secret Manager | GCP_SA_KEY | - | サービスアカウントキー |
| Secret Manager | DATABASE_URL | - | 旧方式（未使用）|

## GitHub Secrets

| Secret | 用途 |
|---|---|
| GCP_SA_KEY | GCP サービスアカウントキー JSON（gcloud 認証用）|
| DEPLOY_SSH_PRIVATE_KEY | SSH 秘密鍵（VM へのデプロイ用）|
| RAILS_MASTER_KEY | Rails マスターキー（未使用 - Secret Manager から取得に変更）|
| DATABASE_URL | DB 接続 URL（未使用 - 個別 env var に変更）|

## Google OAuth Client IDs（GCP project: workoutride-app）

| Platform | Client ID |
|---|---|
| iOS | `432477473655-996lt8d5j3aa4p0e3stvajonld4nfooh.apps.googleusercontent.com` |
| Android | （要確認）|
| Web | `432477473655-2ovs5abgvf6cu6ke9gli7b5phgi0je4u.apps.googleusercontent.com` |
| Backend（GOOGLE_CLIENT_ID）| Web Client ID を使用 |

## VM の手動設定（コードに含まれないもの）

```bash
# IP forwarding 有効化（Docker → Cloud SQL 通信に必要）
sudo sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
sudo sh -c 'echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf'

# Swap 追加（e2-micro の OOM 対策、以前の構築時に設定）
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

## 次のステップ

- [ ] staging リソースを production にリネーム（VM / Cloud SQL / 静的 IP を再作成）
- [x] フロントエンドの API_BASE_URL を `https://34.138.232.78.nip.io` に設定（GitHub Secret `API_BASE_URL` で CI/CD 注入）
- [ ] カスタムドメイン取得・設定（nip.io からの移行）
- [ ] CI/CD のイメージ prune 自動化（ディスク節約）
