import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:workoutride/app/auth_controller.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/auth/auth_state.dart';
import 'package:workoutride/domain/model/auth/user.dart';
import 'package:workoutride/domain/repository/auth_repository.dart';

import 'auth_controller_test.mocks.dart';

// 401 を受けたときに未認証へ落ちることを守るテスト。
// 以前は data 層の AuthInterceptor が ui 層の Notifier を直接叩いていた。
// いまは Repository の sessionExpired を購読する形になっており、
// この経路が切れるとユーザーはログイン画面へ戻されなくなる。
@GenerateMocks([AuthRepository])
void main() {
  late ProviderContainer container;
  late MockAuthRepository mockRepository;
  late StreamController<void> sessionExpired;

  const testUser = User(id: 1, provider: 'google', uid: 'uid-1');

  setUp(() {
    mockRepository = MockAuthRepository();
    sessionExpired = StreamController<void>.broadcast();
    when(mockRepository.sessionExpired)
        .thenAnswer((_) => sessionExpired.stream);

    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
    sessionExpired.close();
  });

  // autoDispose なため、リスナーを張って async 完了までプロバイダを生存させる。
  void keepAlive() => container.listen(authControllerProvider, (_, __) {});

  group('AuthController', () {
    test('保存済みトークンで復帰できれば authenticated になる', () async {
      when(mockRepository.getCurrentUser()).thenAnswer((_) async => testUser);

      keepAlive();
      await container.read(authControllerProvider.future);

      expect(
        container.read(authControllerProvider).value,
        const AuthState.authenticated(user: testUser),
      );
    });

    test('トークンが無ければ unauthenticated になる', () async {
      when(mockRepository.getCurrentUser()).thenAnswer((_) async => null);

      keepAlive();
      await container.read(authControllerProvider.future);

      expect(
        container.read(authControllerProvider).value,
        const AuthState.unauthenticated(),
      );
    });

    test('401 の通知を受けたら unauthenticated へ落ちる', () async {
      when(mockRepository.getCurrentUser()).thenAnswer((_) async => testUser);

      keepAlive();
      await container.read(authControllerProvider.future);
      expect(
        container.read(authControllerProvider).value,
        const AuthState.authenticated(user: testUser),
      );

      // 通信の途中でサーバーに認証を拒否された、という想定。
      sessionExpired.add(null);
      await Future<void>.delayed(Duration.zero);

      expect(
        container.read(authControllerProvider).value,
        const AuthState.unauthenticated(),
      );
    });

    test('signOut は Repository に委譲し unauthenticated にする', () async {
      when(mockRepository.getCurrentUser()).thenAnswer((_) async => testUser);
      when(mockRepository.signOut()).thenAnswer((_) async {});

      keepAlive();
      await container.read(authControllerProvider.future);

      await container.read(authControllerProvider.notifier).signOut();

      verify(mockRepository.signOut()).called(1);
      expect(
        container.read(authControllerProvider).value,
        const AuthState.unauthenticated(),
      );
    });
  });
}
