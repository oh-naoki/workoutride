import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/domain/model/auth/auth_state.dart';
import 'package:workoutride/di/providers.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  Future<AuthState> build() async {
    final repo = ref.read(authRepositoryProvider);

    // 通信中に 401 が返ったら未認証へ落とす。トークンの破棄は data 層が済ませて
    // いるので、ここでは状態を合わせるだけでよい。
    final subscription = repo.sessionExpired.listen((_) {
      state = const AsyncValue.data(AuthState.unauthenticated());
    });
    ref.onDispose(subscription.cancel);

    final user = await repo.getCurrentUser();

    if (user == null) {
      return const AuthState.unauthenticated();
    }

    return AuthState.authenticated(user: user);
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.data(AuthState.loading());

    try {
      final user = await ref.read(authRepositoryProvider).signInWithGoogle();
      state = AsyncValue.data(AuthState.authenticated(user: user));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncValue.data(AuthState.unauthenticated());
  }

  /// アカウントと全データを削除する。失敗時は例外を投げ、認証状態は変えない。
  Future<void> deleteAccount() async {
    await ref.read(authRepositoryProvider).deleteAccount();
    state = const AsyncValue.data(AuthState.unauthenticated());
  }

  Future<void> signInAsDebugUser() async {
    assert(kDebugMode, 'signInAsDebugUser must only be called in debug mode');
    state = const AsyncValue.data(AuthState.loading());

    try {
      final token = dotenv.env['DEBUG_AUTH_TOKEN'];
      if (token == null || token.isEmpty) {
        throw Exception('DEBUG_AUTH_TOKEN is not set in .env');
      }
      const storage = FlutterSecureStorage();
      await storage.write(key: 'auth_token', value: token);

      final user = await ref.read(authRepositoryProvider).getCurrentUser();
      if (user == null) throw Exception('Failed to get user with debug token');

      state = AsyncValue.data(AuthState.authenticated(user: user));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
