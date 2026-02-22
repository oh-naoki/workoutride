import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/domain/model/auth/auth_state.dart';
import 'package:workoutride/di/providers.dart';

part 'auth_state_notifier.g.dart';

@riverpod
class AuthStateNotifier extends _$AuthStateNotifier {
  @override
  Future<AuthState> build() async {
    final repo = ref.read(authRepositoryProvider);
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
}
