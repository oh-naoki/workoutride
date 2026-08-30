import 'package:workoutride/domain/model/auth/user.dart';

abstract class AuthRepository {
  Future<User> signInWithGoogle();
  Future<void> signOut();
  Future<void> deleteAccount();
  Future<User?> getCurrentUser();

  /// サーバーに認証を拒否された（401）ことの通知。
  ///
  /// トークンの失効はユーザー操作ではなく通信の途中で判明するため、
  /// data 層が上位へ伝える経路が要る。data 層から `ui`/`app` を直接呼ぶと
  /// 下位層が上位層を知ることになる（docs/architecture.md §3）ので、
  /// この Stream を上位に購読させる形にしている。
  ///
  /// 購読側（`AuthController`）は未認証状態へ遷移させる責務を持つ。
  /// 保存済みトークンの破棄は data 層が行うため、購読側は状態だけ更新すればよい。
  Stream<void> get sessionExpired;
}
