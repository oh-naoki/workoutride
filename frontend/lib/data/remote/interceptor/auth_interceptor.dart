import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workoutride/ui/auth/auth_state_notifier.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;
  final Ref _ref;
  static const _tokenKey = 'auth_token';

  AuthInterceptor(this._secureStorage, this._ref);

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
      // 401エラー時はトークンを削除し、未認証状態に遷移してログイン画面へ誘導
      _secureStorage.delete(key: _tokenKey);
      _ref.read(authStateNotifierProvider.notifier).signOut();
    }
    handler.next(err);
  }
}
