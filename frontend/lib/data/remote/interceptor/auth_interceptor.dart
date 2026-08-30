import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workoutride/data/remote/auth_session_signal.dart';

/// 全リクエストに保存済みトークンを付け、401 を受けたらセッション切れを知らせる。
///
/// 以前はここから直接 ui 層の認証状態を書き換えていたが、data 層が上位層を
/// 参照することになるため（docs/architecture.md §3）、同じ data 層の
/// [AuthSessionSignal] へ流すだけに変えた。これは Repository の
/// `sessionExpired` として上位へ届き、未認証状態への遷移は購読側が行う。
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;
  final AuthSessionSignal _sessionSignal;

  static const _tokenKey = 'auth_token';

  AuthInterceptor(this._secureStorage, this._sessionSignal);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(key: _tokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // 失効したトークンを残しておく理由がないので破棄する。
      _secureStorage.delete(key: _tokenKey);
      _sessionSignal.notifyExpired();
    }
    handler.next(err);
  }
}
