import 'dart:async';

/// 「サーバーに認証を拒否された」ことを data 層の中で受け渡すための小さな器。
///
/// 発火するのは通信層（`AuthInterceptor`）、公開するのは `AuthRepositoryImpl`。
/// どちらも data 層なので、この受け渡しは層をまたがない。
/// 上位層へは Repository の `sessionExpired` として届く。
///
/// broadcast にしているのは、購読者が居ない時点で発火しても捨てられる必要が
/// あるため（起動直後など）。単一購読の Stream だと通知が溜まってしまう。
class AuthSessionSignal {
  final _controller = StreamController<void>.broadcast();

  Stream<void> get expired => _controller.stream;

  void notifyExpired() {
    if (!_controller.isClosed) {
      _controller.add(null);
    }
  }

  void dispose() {
    _controller.close();
  }
}
