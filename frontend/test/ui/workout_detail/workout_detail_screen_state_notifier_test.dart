import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/user_profile.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/workout/workout_summary.dart';
import 'package:workoutride/domain/repository/workout_repository.dart';
import 'package:workoutride/domain/usecase/user_profile/get_user_profile_use_case.dart';
import 'package:workoutride/ui/workout_detail/workout_detail_screen_state_notifier.dart';

import 'workout_detail_screen_state_notifier_test.mocks.dart';

// このテストはリファクタ前の「現状の振る舞い」を固定する characterization test。
// PR⑤（View薄化）で挙動が変わったら赤くなる安全網。
// PR③で notifier が UseCase → WorkoutRepository 直呼びに変わったため、
// mock の配線を Repository に付け替えたが、検証する UiState 挙動は不変。
@GenerateMocks([
  WorkoutRepository,
  GetUserProfileUseCase,
])
void main() {
  late ProviderContainer container;
  late MockWorkoutRepository mockWorkoutRepository;
  late MockGetUserProfileUseCase mockGetUserProfileUseCase;

  const testWorkoutId = 1;

  final testSummary = WorkoutSummary(
    id: testWorkoutId,
    name: 'テストワークアウト',
    totalDuration: 900,
    category: 'エンデュランス',
    createdAt: DateTime(2023, 1, 1),
    updatedAt: DateTime(2023, 1, 1),
  );

  final testBlocks = [
    WorkoutBlock(
      id: 1,
      workoutId: testWorkoutId,
      blockType: 'ウォームアップ',
      targetFtpPercentage: 60,
      durationSeconds: 300,
      orderIndex: 1,
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
    ),
    WorkoutBlock(
      id: 2,
      workoutId: testWorkoutId,
      blockType: 'メイン',
      targetFtpPercentage: 90,
      durationSeconds: 600,
      orderIndex: 2,
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
    ),
  ];

  ProviderContainer buildContainer() => ProviderContainer(
        overrides: [
          workoutRepositoryProvider.overrideWithValue(mockWorkoutRepository),
          getUserProfileUseCaseProvider
              .overrideWithValue(mockGetUserProfileUseCase),
        ],
      );

  // autoDispose なため、リスナーを張って async 完了までプロバイダを生存させる。
  void keepAlive() => container.listen(
        workoutDetailScreenStateNotifierProvider(testWorkoutId),
        (_, __) {},
      );

  setUp(() {
    mockWorkoutRepository = MockWorkoutRepository();
    mockGetUserProfileUseCase = MockGetUserProfileUseCase();
    container = buildContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('WorkoutDetailScreenStateNotifier', () {
    test('初期状態は isLoading=true', () {
      when(mockWorkoutRepository.getWorkoutSummary(testWorkoutId))
          .thenAnswer((_) async => testSummary);
      when(mockWorkoutRepository.getWorkoutBlocks(testWorkoutId))
          .thenAnswer((_) async => testBlocks);
      when(mockGetUserProfileUseCase.call()).thenAnswer(
          (_) async => UserProfile(weight: 70, ftp: 250, updatedAt: DateTime(2023)));

      final state = container
          .read(workoutDetailScreenStateNotifierProvider(testWorkoutId));

      expect(state.isLoading, true);
      expect(state.workoutBlocks, isEmpty);
      expect(state.workoutSummary, isNull);
    });

    test('サマリ・ブロックを取得して UiState に反映する', () async {
      when(mockWorkoutRepository.getWorkoutSummary(testWorkoutId))
          .thenAnswer((_) async => testSummary);
      when(mockWorkoutRepository.getWorkoutBlocks(testWorkoutId))
          .thenAnswer((_) async => testBlocks);
      when(mockGetUserProfileUseCase.call()).thenAnswer(
          (_) async => UserProfile(weight: 70, ftp: 250, updatedAt: DateTime(2023)));

      keepAlive();
      container
          .read(workoutDetailScreenStateNotifierProvider(testWorkoutId).notifier);
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container
          .read(workoutDetailScreenStateNotifierProvider(testWorkoutId));
      expect(state.isLoading, false);
      expect(state.errorMessage, isNull);
      expect(state.workoutSummary, testSummary);
      expect(state.workoutBlocks, testBlocks);
      expect(state.userWeight, 70);
    });

    test('プロフィールが null のときは体重 60.0 にフォールバックする', () async {
      when(mockWorkoutRepository.getWorkoutSummary(testWorkoutId))
          .thenAnswer((_) async => testSummary);
      when(mockWorkoutRepository.getWorkoutBlocks(testWorkoutId))
          .thenAnswer((_) async => testBlocks);
      when(mockGetUserProfileUseCase.call()).thenAnswer((_) async => null);

      keepAlive();
      container
          .read(workoutDetailScreenStateNotifierProvider(testWorkoutId).notifier);
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container
          .read(workoutDetailScreenStateNotifierProvider(testWorkoutId));
      expect(state.userWeight, 60.0);
    });

    test('プロフィール取得が失敗しても体重 60.0 にフォールバックする', () async {
      when(mockWorkoutRepository.getWorkoutSummary(testWorkoutId))
          .thenAnswer((_) async => testSummary);
      when(mockWorkoutRepository.getWorkoutBlocks(testWorkoutId))
          .thenAnswer((_) async => testBlocks);
      when(mockGetUserProfileUseCase.call())
          .thenThrow(Exception('profile error'));

      keepAlive();
      container
          .read(workoutDetailScreenStateNotifierProvider(testWorkoutId).notifier);
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container
          .read(workoutDetailScreenStateNotifierProvider(testWorkoutId));
      expect(state.userWeight, 60.0);
    });

    test('取得に失敗したら errorMessage を立てて isLoading=false にする', () async {
      when(mockWorkoutRepository.getWorkoutSummary(testWorkoutId))
          .thenThrow(Exception('load error'));
      when(mockWorkoutRepository.getWorkoutBlocks(testWorkoutId))
          .thenAnswer((_) async => testBlocks);
      when(mockGetUserProfileUseCase.call()).thenAnswer(
          (_) async => UserProfile(weight: 70, ftp: 250, updatedAt: DateTime(2023)));

      keepAlive();
      container
          .read(workoutDetailScreenStateNotifierProvider(testWorkoutId).notifier);
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container
          .read(workoutDetailScreenStateNotifierProvider(testWorkoutId));
      expect(state.isLoading, false);
      expect(state.errorMessage, isNotNull);
    });

    test('refreshWorkoutBlocks で再取得できる', () async {
      when(mockWorkoutRepository.getWorkoutSummary(testWorkoutId))
          .thenAnswer((_) async => testSummary);
      when(mockWorkoutRepository.getWorkoutBlocks(testWorkoutId))
          .thenAnswer((_) async => testBlocks);
      when(mockGetUserProfileUseCase.call()).thenAnswer(
          (_) async => UserProfile(weight: 70, ftp: 250, updatedAt: DateTime(2023)));

      keepAlive();
      final notifier = container
          .read(workoutDetailScreenStateNotifierProvider(testWorkoutId).notifier);
      await Future.delayed(const Duration(milliseconds: 50));

      await notifier.refreshWorkoutBlocks(testWorkoutId);

      final state = container
          .read(workoutDetailScreenStateNotifierProvider(testWorkoutId));
      expect(state.workoutBlocks, testBlocks);
      // build時 + refresh時 の 2 回呼ばれる
      verify(mockWorkoutRepository.getWorkoutBlocks(testWorkoutId)).called(2);
    });
  });
}
