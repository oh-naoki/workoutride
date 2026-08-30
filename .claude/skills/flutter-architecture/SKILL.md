---
name: flutter-architecture
description: WorkoutRide の Flutter アプリ（frontend/）でコードを追加・変更するときのアーキテクチャ規約と機械的な違反チェック。View/ViewModel/Repository/Service の4層 MVVM、domain→data の import 禁止（黄金律）、UseCase を作ってよい条件、DTO の閉じ込め方を扱う。frontend/lib 配下のファイルを新規作成・リファクタする前、および PR を出す前に使う。
---

# Flutter アーキテクチャ規約（WorkoutRide）

正典は **`docs/architecture.md`**。このスキルは「実際に手を動かすときの判断」と「機械的な検証手順」に絞る。
構造を変える前・PR を出す前に、下記の検証コマンドを必ず流すこと。

## 判断に迷ったときの分岐

**新しいコードをどこに置くか**

| 書きたいもの | 置き場所 |
|---|---|
| 画面の描画 | `ui/<feature>/xxx_screen.dart` |
| 画面の状態・ユーザー操作の受け口 | `ui/<feature>/xxx_screen_state_notifier.dart`（実体は ViewModel） |
| API/BLE/ストレージへのアクセス窓口 | `data/` の Service（`Future`/`Stream` のみ返す。状態を持たない） |
| データ取得の正規窓口・DTO→ドメイン変換 | IF は `domain/repository/`、実装は `data/repository/` |
| 複数 Repository の統合／単独で複雑なロジック | `domain/usecase/`（**条件を満たすときだけ**） |
| 外部依存のない純粋な計算 | `domain/service/`（例 `PowerZoneAnalyzer`, `WorkoutResultRecorder`） |

**UseCase を作ってよいか** — 次のどれかに当てはまるときだけ作る。

- 複数の Repository を統合する
- 状態機械・時系列処理・集計など単独で複雑
- 複数の ViewModel から再利用される

`repo.someMethod()` を呼ぶだけのラッパは**作らない**。ViewModel から Repository を直接呼ぶ。

**型変換をどこに書くか** — DTO↔ドメインの変換は必ず `data/` の中（Repository 実装か `data/remote/model/extensions.dart` の `toDomain()`）。
外部ライブラリの型（`flutter_blue_plus` の `ScanResult` 等）をドメインモデルに変換するのも `data/` の責務。

## 絶対に守る3点

1. **黄金律**: `domain/` から `data/` を import しない。外部 I/O は Repository IF 越しに触る。
2. **逆流も禁止**: `data/` から `ui/`（や他の上位層）を import しない。
   下位層が上位層を知るのは黄金律より悪い。data 層が上位に何かを伝えたいときは、
   **Repository IF に通知手段（`Stream` 等）を生やして上位に購読させる**。
   data から呼んでよいのは `domain/model` と `domain/repository` だけ。
3. **DTO を閉じ込める**: `data/remote/model/` の型は `ui/` にも `domain/` にも出さない。Repository の公開型は常にドメインモデル。
4. **View にロジックを書かない**: データ取得（`FutureBuilder` + Repository 直呼び）も集計も禁止。すべて ViewModel の `UiState`（Freezed）へ。

状態管理は `@riverpod` codegen の `Notifier` のみ。旧 `StateNotifier`/`StateProvider` は新規で使わない。

## 機械的チェック（変更後・PR 前に実行）

> **必ずリポジトリのルートから実行すること。** ディレクトリを間違えると
> grep が対象を見つけられず、違反があっても「なし ✓」と表示されてしまう。
> 下のスクリプトは先頭で対象ディレクトリの存在を確認して落とすようにしてある。

```bash
cd "$(git rev-parse --show-toplevel)/frontend/lib" || exit 1
for d in domain ui data component; do
  [ -d "$d" ] || { echo "ERROR: $d が無い。実行位置が違う"; exit 1; }
done

echo "=== 黄金律: domain/ が data/ を import ==="
grep -rn "import.*['\"].*data/" domain/ || echo "  なし ✓"

echo "=== ui/ が data/ を import ==="
grep -rn "import.*['\"].*data/" ui/ || echo "  なし ✓"

echo "=== 逆流: data/ が上位層を import ==="
grep -rnE "import.*['\"].*(ui|app)/" data/ || echo "  なし ✓"

echo "=== 逆流: domain/ が ui/ を import ==="
grep -rn "import.*['\"].*ui/" domain/ || echo "  なし ✓"

echo "=== View 内のデータ取得 ==="
grep -rn "FutureBuilder\|StreamBuilder" ui/ component/ || echo "  なし ✓"

echo "=== 旧 StateNotifier の実装 ==="
grep -rnE "extends StateNotifier|(^|[^A-Za-z0-9_])(StateNotifierProvider|StateProvider)\(" \
  --include="*.dart" . | grep -v "\.g\.dart" || echo "  なし ✓"

echo "=== DTO の越境（コメント行は除外） ==="
grep -rnE "(^|[^A-Za-z0-9_])[A-Z][A-Za-z0-9]*Dto\b|SaveWorkoutResultRequest" ui/ domain/ \
  | grep -vE "^[^:]+:[0-9]+: *(///|//|\*)" || echo "  なし ✓"
```

いずれかがヒットしたら、その変更は規約違反。`docs/architecture.md` の該当節を読んで直す。

> 注: 上2つの grep が `-E` と前方の文字クラスを使っているのは誤検出を避けるため。
> プロバイダ名 `xxxScreenStateNotifierProvider` は歴史的経緯で `StateNotifier` を含むが実体は
> codegen の `Notifier` なので、単純な `grep "StateNotifierProvider"` だと全 ViewModel が引っかかる。
> DTO 側も `workout_result_draft.dart` の説明コメントが引っかかるためコメント行を除外している。

## 薄い UseCase を見つけたら

```bash
# 20行未満の UseCase は委譲だけの可能性が高い
find frontend/lib/domain/usecase -name "*.dart" -exec wc -l {} + | sort -n | head
```

中身が `_repo.x()` を返すだけなら廃止し、呼び出し元の ViewModel から Repository を直接呼ぶ形に変える。

## コード変更後に必ず流す

```bash
cd frontend
dart run build_runner build --delete-conflicting-outputs   # Freezed/Riverpod/Retrofit を触ったら必須
flutter analyze
flutter test
dart format <変更したファイルのみ>   # lib test 全体を format しない（無関係な差分が出る）
```

## PR 前チェックリスト

- [ ] 上の機械的チェックが全て「なし ✓」
- [ ] 新しい UseCase を足したなら、作成条件のどれに当たるか説明できる
- [ ] Repository の公開型・引数・戻り値にドメインモデル以外が混ざっていない
- [ ] View に描画以外のロジックがない
- [ ] `flutter analyze` / `flutter test` がグリーン
- [ ] `docs/architecture.md` §7 の逸脱一覧と実態がずれていないか（直したなら消す、増えたなら書く）
