import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/user_profile.dart';
import 'package:workoutride/domain/repository/user_profile_repository.dart';
import 'package:workoutride/ui/settings/settings_screen_state_notifier.dart';

import 'settings_screen_state_notifier_test.mocks.dart';

// 体重・FTP の取得と保存が ViewModel に一本化されたことを守るテスト。
// 以前は FTP を View の FutureBuilder が取得し、体重はダイアログと
// ViewModel の両方が保存していた（PUT が2回飛ぶ不具合）。
@GenerateMocks([UserProfileRepository])
void main() {
  late ProviderContainer container;
  late MockUserProfileRepository mockRepository;

  final testProfile = UserProfile(
    weight: 65.5,
    ftp: 240,
    updatedAt: DateTime(2026, 8, 30),
  );

  ProviderContainer buildContainer() => ProviderContainer(
        overrides: [
          userProfileRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

  // autoDispose なため、リスナーを張って async 完了までプロバイダを生存させる。
  void keepAlive() =>
      container.listen(settingsScreenStateNotifierProvider, (_, __) {});

  setUp(() {
    mockRepository = MockUserProfileRepository();
    container = buildContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('SettingsScreenStateNotifier', () {
    test('体重と FTP をまとめて読み込んで UiState に反映する', () async {
      when(mockRepository.getUserProfile())
          .thenAnswer((_) async => testProfile);
      when(mockRepository.getFtp()).thenAnswer((_) async => 240);

      keepAlive();
      await Future<void>.delayed(Duration.zero);

      final state = container.read(settingsScreenStateNotifierProvider);
      expect(state.isLoading, false);
      expect(state.currentWeight, 65.5);
      expect(state.currentFtp, 240);
      expect(state.errorMessage, isNull);
    });

    test('FTP 未設定なら currentFtp は null のまま', () async {
      when(mockRepository.getUserProfile()).thenAnswer((_) async => null);
      when(mockRepository.getFtp()).thenAnswer((_) async => null);

      keepAlive();
      await Future<void>.delayed(Duration.zero);

      final state = container.read(settingsScreenStateNotifierProvider);
      expect(state.currentFtp, isNull);
      expect(state.currentWeight, isNull);
    });

    test('updateWeight は saveWeight を1回だけ呼ぶ', () async {
      when(mockRepository.getUserProfile())
          .thenAnswer((_) async => testProfile);
      when(mockRepository.getFtp()).thenAnswer((_) async => 240);
      when(mockRepository.saveWeight(any)).thenAnswer((_) async {});

      keepAlive();
      await Future<void>.delayed(Duration.zero);

      await container
          .read(settingsScreenStateNotifierProvider.notifier)
          .updateWeight(70.0);

      // ダイアログ側でも保存していた頃は 2 回呼ばれていた。
      verify(mockRepository.saveWeight(70.0)).called(1);
      expect(container.read(settingsScreenStateNotifierProvider).currentWeight,
          70.0);
    });

    test('updateFtp は saveFtp を呼び UiState を更新する', () async {
      when(mockRepository.getUserProfile())
          .thenAnswer((_) async => testProfile);
      when(mockRepository.getFtp()).thenAnswer((_) async => 240);
      when(mockRepository.saveFtp(any)).thenAnswer((_) async {});

      keepAlive();
      await Future<void>.delayed(Duration.zero);

      await container
          .read(settingsScreenStateNotifierProvider.notifier)
          .updateFtp(260);

      verify(mockRepository.saveFtp(260)).called(1);
      expect(
          container.read(settingsScreenStateNotifierProvider).currentFtp, 260);
    });

    test('読み込み失敗時は errorMessage を立てて isLoading を落とす', () async {
      // 実際の通信失敗は非同期に起きる。thenThrow による同期 throw だと
      // build() が返す初期 state に上書きされてしまい、現実と乖離する。
      when(mockRepository.getUserProfile())
          .thenAnswer((_) async => throw Exception('boom'));
      when(mockRepository.getFtp()).thenAnswer((_) async => 240);

      keepAlive();
      await Future<void>.delayed(Duration.zero);

      final state = container.read(settingsScreenStateNotifierProvider);
      expect(state.isLoading, false);
      expect(state.errorMessage, isNotNull);
    });
  });
}
