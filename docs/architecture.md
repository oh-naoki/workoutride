# WorkoutRide フロントエンド アーキテクチャガイド

> このドキュメントは **WorkoutRide の Flutter アプリが目指すアーキテクチャ**を定義する。
> 後続の開発者・AI が「どこに何を書くか」「この変更は正しい方向か」を判断する
> **単一の基準**として参照すること。現状はこの理想形に一部未達であり、
> 末尾の [現状の逸脱と移行計画](#現状の逸脱と移行計画) に沿って段階的に近づけていく。

- **対象**: `frontend/`（Flutter + Riverpod）
- **準拠する基準**: [Flutter 公式 App Architecture Guide](https://docs.flutter.dev/app-architecture/guide)（MVVM）
- **最終更新**: 2026-08-30
- **実作業時の手引き**: `.claude/skills/flutter-architecture/SKILL.md`（判断の分岐・違反の機械的検出コマンド）

---

## 0. 基本方針（3行で）

1. **Flutter 公式の MVVM に合わせる** — View / ViewModel / Repository / Service の4役。
2. **domain（use-case）層は「任意」**。薄いラッパは作らない。**必要なときだけ**足す。
3. **依存は常に UI → Data の一方向**。逆流（domain が data の型を知る等）は禁止。

> 重要な考え方: 本アプリの"古さ"は状態管理ではなく **use-case 層の作りすぎ**にある。
> モダン化とは抽象を足すことではなく、**不要な層を削って素直にすること**である。

---

## 1. レイヤ構成

```
┌─────────────────────────────────────────────────────────┐
│ UI 層 (ui/)                                              │
│   View (Widget)      … 描画だけ。ロジックを持たない        │
│   ViewModel          … UI状態の生成・保持・Command公開     │
│        │  ref.watch(state) ↓      ↑ command()             │
├────────┼─────────────────────────────────────────────────┤
│ (Domain 層 domain/usecase/  … 任意・条件を満たすときだけ)  │
│   UseCase            … 複数Repoの統合／複雑ロジックの集約   │
├────────┼─────────────────────────────────────────────────┤
│ Data 層 (data/)                                          │
│   Repository         … 信頼できる唯一の源・ドメイン型を返す │
│   Service            … 1データソースを包む・Future/Stream  │
└─────────────────────────────────────────────────────────┘
             ↓ 外部（REST API / BLE / 端末ストレージ）
```

**データの流れ**
- **下り（状態）**: Service が生データ → Repository がドメインモデルへ変換・集約 → ViewModel が UI 状態へ整形 → View が描画
- **上り（イベント）**: View のジェスチャ → ViewModel の **Command**（メソッド）を呼ぶ → Repository/UseCase を実行

---

## 2. 各レイヤの責務と規約

### 2.1 View（`ui/**/xxx_screen.dart` 等）

- **やること**: 描画のみ。`ref.watch` で ViewModel の状態を読み、`ref.read(...notifier).command()` を呼ぶ。
- **やってよい最小ロジック**: 表示条件の `if`、アニメーション、レイアウト、単純な画面遷移。
- **禁止**:
  - ❌ Widget 内でデータ取得（`FutureBuilder` + UseCase/Repository 直呼び）。→ ViewModel に吸い上げる。
  - ❌ `data/` の型（DTO・ApiClient・DataSource）を import する。
  - ❌ ビジネスロジック（集計・変換・判定）を書く。

### 2.2 ViewModel（`ui/**/xxx_screen_state_notifier.dart`）

> 命名は歴史的に `XxxScreenStateNotifier` だが、**実体は ViewModel**。当面リネームはしない
> （公式も命名は自由）。役割が ViewModel であることを意識する。

- **やること**:
  - Repository / UseCase から受け取ったデータを **UI 状態（Freezed の `XxxUiState`）に整形**（フィルタ・ソート・集約）。
  - UI 固有の状態（ローディング、選択中インデックス、カウントダウン等）を保持。
  - **Command** を公開する = ユーザー操作に対応した名前付きメソッド（`retryBleConnection()`, `togglePauseResume()` 等）。
- **実装規約**:
  - **Riverpod codegen `@riverpod` + `Notifier`** で書く（`extends _$Xxx`）。旧 `StateNotifier` は使わない。
  - UI 状態は **Freezed の immutable class**。`state = state.copyWith(...)` で更新。
  - View と 1:1。
- **禁止**:
  - ❌ `data/` の型を直接組み立てる／import する（例: DTO を new する）。ドメインモデルだけを扱う。
  - ❌ 500行級の肥大化。集計・結果組み立て等の**再利用可能／複雑なロジックは domain（service/usecase）へ出す**。

### 2.3 Repository（`domain/repository/*.dart` = IF, `data/repository/*_impl.dart` = 実装）

- **やること**:
  - アプリにとっての **信頼できる唯一の源(single source of truth)**。
  - Service から取得した生データ／DTO を **ドメインモデルに変換**して返す。
  - キャッシュ・エラー処理・リトライ・（あれば）ポーリングなどの**データ都合のロジック**を持つ。
- **規約**:
  - インターフェースを `domain/repository/` に置き、実装を `data/repository/` に置く（依存逆転）。
  - **公開する型・引数・戻り値はすべてドメインモデル**。DTO を漏らさない。
  - Repository 同士は互いを知らない（統合が必要なら ViewModel か UseCase で行う）。

### 2.4 Service（`data/remote/**`, `data/ble_connector.dart` 等）

> 現状の `WorkoutApiClient`（Retrofit）／`WorkoutRemoteDataSource`／`BleConnector` が
> 公式でいう **Service** に相当する。

- **やること**: **1つのデータソース**（REST の1系統、BLE、端末ストレージ）を包む薄い窓口。
- **規約**:
  - 公開するのは `Future` / `Stream` のみ。**状態を持たない**。
  - 1データソース = 1 Service。
- **DTO の所在**: `data/remote/model/`。**Service より外（domain/ui）に出さない**。DTO↔ドメイン変換は `data/` 内（現状は `extensions.dart` の `toDomain()` / DataSource）で行う。

### 2.5 Model

- **ドメインモデル**（`domain/model/**`）: アプリが扱う正規の型。Freezed。UI・ViewModel・Repository が共有。
- **DTO**（`data/remote/model/**`）: API の JSON 形状に対応。snake_case 可。**data 層に閉じる**。

### 2.6 UseCase（`domain/usecase/**`）— **任意**

**作ってよい条件（いずれか）:**
- 複数の Repository を**統合**する必要がある。
- ロジックが**単独で複雑**（時系列処理・状態機械・集計など）。
- 同じロジックを**複数の ViewModel で再利用**する。

**作ってはいけない例（＝今削るべきもの）:**
- ❌ Repository の1メソッドをそのまま呼ぶだけの薄いラッパ
  （例: `GetWorkoutSummariesUseCase.call() => repo.getWorkoutSummaries()`）。
  → **廃止し、ViewModel が Repository を直接呼ぶ**。

**現状 残すべき UseCase の例:**
- `ManageWorkoutUseCase` — ワークアウト進行の状態機械・複数入力の統合。
- `GetCalculatedPowerMeterDataUseCase` — 3秒移動平均という独立した変換ロジック。
- 結果集計（現在 ViewModel 内。将来 `WorkoutResultRecorder` 等の service/usecase へ抽出したい）。

---

## 3. 依存ルール（違反はレビューで弾く）

| From ↓ / 参照可否 → | ui | domain/model | domain/repository(IF) | domain/usecase | data |
|---|---|---|---|---|---|
| **ui (View/ViewModel)** | ✅ | ✅ | ✅ | ✅(必要時) | ❌ |
| **domain/usecase** | ❌ | ✅ | ✅ | ✅ | ❌ |
| **domain/repository(IF)** | ❌ | ✅ | ❌ | ❌ | ❌ |
| **data (impl/service)** | ❌ | ✅ | ✅(implする) | ❌ | ✅ |

- **黄金律**: `domain/` は `data/` を **import してはならない**。
- ViewModel は「単純な読み書き = Repository 直呼び」「複雑・統合 = UseCase 経由」を使い分ける。
- BLE も含め、外部I/Oは Service に隔離し、ドメインは Repository IF 越しに触る。

---

## 4. 状態管理・DI 規約

- **状態管理**: Riverpod（**codegen `@riverpod`** を標準）。`flutter_riverpod` + `riverpod_annotation`。
  - ViewModel = `@riverpod class Xxx extends _$Xxx`。
  - グローバル/共有状態も `@riverpod`。**旧 `StateNotifier` / `StateProvider` は新規で使わない**。
- **DI**: `di/providers.dart` に `@riverpod` プロバイダを定義。
  - 将来は機能ドメイン別（auth / workout / ble / profile）に分割したい（[移行計画](#現状の逸脱と移行計画) Phase 5）。
- **Command**: ユーザー操作は ViewModel の名前付きメソッドとして公開し、View から `ref.read(provider.notifier).command()` で呼ぶ。
- **Riverpod 3.0**: 2026 時点で stable 済み。ただし「移行版で 4.0 が早期に来る可能性」「初期バグ枯れ待ち」の指摘あり。
  本アプリは既に codegen Notifier ベースで 3.0 と親和的なため、**移行は急がず独立フェーズで**（Phase 6）。

---

## 5. ディレクトリ規約（現状 = レイヤーファースト）

```
lib/
├── main.dart
├── di/providers.dart          … DI（@riverpod）
├── ui/<feature>/              … View + ViewModel(=StateNotifier) + UiState
├── domain/
│   ├── model/                 … ドメインモデル(Freezed)
│   ├── repository/            … Repository インターフェース
│   ├── usecase/               … UseCase（条件を満たすものだけ）
│   └── service/               … 純粋ドメインサービス(例 PowerZoneAnalyzer)
├── data/
│   ├── repository/            … Repository 実装
│   ├── remote/{api,model,interceptor}/ … Service(ApiClient)・DTO
│   └── ble_connector.dart, power_meter_data_source.dart … BLE Service
└── component/                 … 汎用 UI 部品
```

- 現状は **レイヤーファースト**。公式は feature-first を示唆するが、**移行コストが高いため当面維持**。
  将来 feature-first へ寄せる場合は別途大きめのフェーズとして扱う（Phase 6）。

---

## 6. コード規約（Before → After の指針）

### 6.1 薄い UseCase を削り、ViewModel が Repository を直接呼ぶ

```dart
// ❌ Before: 委譲するだけの UseCase
class GetWorkoutSummariesUseCase {
  final WorkoutRepository _repo;
  GetWorkoutSummariesUseCase(this._repo);
  Future<List<WorkoutSummary>> call() => _repo.getWorkoutSummaries();
}
// ViewModel: ref.read(getWorkoutSummariesUseCaseProvider).call();

// ✅ After: ViewModel が Repository を直接使う
// ViewModel: ref.read(workoutRepositoryProvider).getWorkoutSummaries();
```

### 6.2 View からデータ取得ロジックを追い出す

```dart
// ❌ Before: Widget 内で取得（ui/workout_detail の WorkoutMenu）
FutureBuilder<int?>(
  future: ref.read(getUserFtpUseCaseProvider).call(),
  builder: (context, snapshot) { ... },
);

// ✅ After: ViewModel が FTP を取得して UiState に載せ、View は state を描くだけ
final ftp = ref.watch(workoutDetailViewModelProvider(id)).ftp;
```

### 6.3 DTO を UI/domain に漏らさない

```dart
// ❌ Before: UI/ドメインIF が data 層 DTO を扱う
//   domain/repository/workout_repository.dart が SaveWorkoutResultRequest(=DTO) を引数に取る
//   ui/workout/...notifier.dart が SaveWorkoutResultRequest を組み立てる

// ✅ After: ドメインモデルを引数にし、DTO 変換は data 層で行う
abstract class WorkoutRepository {
  Future<WorkoutResult> saveWorkoutResult(WorkoutResultDraft draft); // ドメイン型
}
// data 層内で draft → SaveWorkoutResultRequest(DTO) に変換して送信
```

---

## 7. 現状の逸脱と移行計画

> 各 Phase は**独立した PR**で進め、CI（RSpec / flutter test / build apk）グリーンを維持する。
> 変更は必ず本ドキュメントの規約に照らして正しい方向か確認する。

> **最終監査日: 2026-08-30**。この一覧は監査のたびに更新すること（直したら消す・増えたら書く）。
> 検出手順は `.claude/skills/flutter-architecture/SKILL.md` の「機械的チェック」を実行する。

### 解決済み（2026-08-30 監査で確認）

A1 / A3 / B1（PR #95 `WorkoutResultDraft` 導入）、B2 / C1（PR #93 codegen 統一）、
B3（PR #96 workout_detail の FTP 取得を ViewModel へ）、D1 大半（PR #94, #97 薄い UseCase 撤廃）、
D2（PR #98 `WorkoutResultRecorder` 抽出）、E2（`di/providers.dart` 286→232行）。

### 現存する逸脱一覧

**なし。** 2026-08-30 の監査で挙がった6件と、その後に見つかった1件（F1）を全て解消した。

> **F1（追加検出）**: `data/remote/interceptor/auth_interceptor.dart` が
> `ui/auth/auth_state_notifier.dart` を import していた。401 を受けたときに UI の
> 認証状態を直接書き換えるためで、**下位層が上位層を参照する**逆流だった。
> 当初のチェックが `domain→data` と `ui→data` しか見ていなかったため素通りしていた。
> → PR #130 で解消。逆流方向のチェックも skill に追加した。

| # | 逸脱だったもの | 解消した PR |
|---|---|---|
| **B4** | ViewModel が `data/audio` を直 import | #125 ドメイン IF 化 |
| **B5** | settings の View 内データ取得（`FutureBuilder`） | #126 ViewModel へ集約 |
| **A2** | BLE にだけ Repository 層が無く UseCase が `data/` を直 import | #127 Repository 層を新設 |
| **D1'** | 薄いラッパ UseCase 2本（純粋な委譲） | #127 削除し Repository 直呼びへ |
| **A4** | `ScanResult`→`DeviceScanResult` 変換が domain 層 | #127 実装側へ移動 |
| **E1** | データ層の段数が不統一（workout のみ3段） | #128 `WorkoutRemoteDataSource` 廃止 |
| **F1** | `data/` が `ui/` を import（逆流） | #130 Repository の `sessionExpired` 経由へ |

これにより **層をまたぐ import は4方向すべてクリーン**
（`domain→data` / `ui→data` / `data→上位` / `domain→ui`）、
**Repository は全ドメインで ApiClient / Connector 直呼びの2段**に揃っている。

> **`lib/app/` について**: 画面に紐つかないアプリ全体の状態（現状は `AuthController` のみ）を置く。
> 認証状態は main.dart のルーティング・ログイン画面・設定画面から使われ、特定の View の
> Model ではないため、`ui/` の ViewModel とは区別している。

> 副産物として #126 で不具合を1件修正した。体重の保存がダイアログと ViewModel の
> 両方で走り、PUT が2回飛んでいた。取得・保存の経路を ViewModel に一本化した結果として
> 顕在化したもの。

### 今後やるとしたら（任意・優先度低）

| 目的 | 内容 | リスク |
|------|------|-------|
| DI 分割 | `di/providers.dart`（232行）を機能ドメイン別に分ける | 中 |
| feature-first | レイヤーファースト → 機能別ディレクトリ | 大 |
| Riverpod 3 移行 | 既に codegen Notifier ベースなので親和性は高い | 中 |

---

## 8. レビュー時チェックリスト

- [ ] `domain/` から `data/` を import していないか。
- [ ] View に描画以外のロジック（取得・集計）が無いか。
- [ ] 新しい UseCase は §2.6 の作成条件を満たすか（委譲だけなら作らない）。
- [ ] ViewModel / Repository の公開型に DTO が漏れていないか。
- [ ] 状態管理は codegen `@riverpod` + Freezed か（旧 StateNotifier を増やしていないか）。
- [ ] 変更は本ドキュメントのどの規約に沿うか説明できるか。

---

## 参考

- [Flutter 公式 — Guide to app architecture](https://docs.flutter.dev/app-architecture/guide)
- [Flutter 公式 — Architecture case study / recommendations](https://docs.flutter.dev/app-architecture)
- [Riverpod](https://riverpod.dev/)（codegen / Notifier）
- 関連: `docs/ble-power-meter-guide.md`（BLE データ抽出の詳細）
