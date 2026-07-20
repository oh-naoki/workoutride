# テスター募集（Twitter/X）ドラフト

**作成日**: 2026-07-20
**前提**: ツイート前に Play Console のクローズドテストトラック作成と Google グループの用意を済ませること（下記の準備手順参照）

---

## 募集ツイート（本文: 約130字）

```
個人開発でインドアサイクリングのAndroidアプリを作りました🚴

Zwift風の構造化ワークアウトをFTPベースで実行、パワーメーターとBLE接続してリアルタイム表示&結果を自動記録するアプリです。

公開前のテスターを募集しています。スマートトレーナー/パワメをお持ちの方、ぜひ🙏

参加手順はリプ欄👇
```

※ スクリーンショットか実行画面の短い動画を添付すると反応が段違いに良くなります

## リプライ（スレッド2件目）

```
参加は2ステップです（Android・14日間ほど使ってもらえると助かります）

① テスター用Googleグループに参加
② テスト版リンクからインストール

詳しい手順はこちら
https://workoutride.ohnaoki.app/testers.html

不具合報告や「ここがイマイチ」も大歓迎です！
```

## ハッシュタグ案（本文に入れるか、3件目のリプで）

`#Zwift` `#ズイフト` `#ローラー台` `#パワーメーター` `#インドアサイクリング` `#個人開発`

---

## 事前準備手順（ツイート前に完了させる）

### 1. Google グループ作成（テスター管理を楽にする）

1. [groups.google.com](https://groups.google.com) で新規グループ作成（例: `workoutride-testers`）
2. グループ設定:
   - 「グループに参加できるユーザー」= **誰でも参加をリクエストできる → 誰でも参加できる**
   - 「グループを表示できるユーザー」= ウェブ上のすべてのユーザー
3. グループのURL（`https://groups.google.com/g/workoutride-testers`）を控える

### 2. Play Console でクローズドテスト設定

1. クローズドテストトラック作成 → AAB アップロード
2. テスター → 「Google グループでテスターを管理」にグループのメールアドレス（`workoutride-testers@googlegroups.com`）を登録
3. **オプトインURL** をコピー（`https://play.google.com/apps/testing/com.github.ohnaoki.workoutride`）

### 3. testers.html のプレースホルダを差し替えてデプロイ

`backend/public/testers.html` 内の2箇所を置換:
- `GOOGLE_GROUP_URL_HERE` → Google グループのURL
- `OPT_IN_URL_HERE` → Play のオプトインURL

mainにマージすれば自動デプロイされ、`https://workoutride.ohnaoki.app/testers.html` で公開される。

### 4. ツイート → 集まり具合を見て追撃

- 12人は最低ライン。**離脱を見込んで20人前後を目標に**
- 3〜4日で集まらなければ、相互テストコミュニティ（r/AndroidClosedTesting等）や有料サービス（Testers Community等）で不足分を補充
- テスト開始（12人がオプトインした状態）から14日のカウントが始まる点に注意

---

## テスト期間中のフォロー

- 週1回程度、グループやXで「使ってみてどうですか」と声かけ（エンゲージメント維持）
- Sentry / Crashlytics でクラッシュ監視（導入済み）
- もらったフィードバックは記録しておく → 本番公開申請時のアンケートでそのまま使える
