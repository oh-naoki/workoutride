import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:workoutride/data/remote/model/save_workout_result_request.dart';
import 'package:workoutride/data/remote/workout_remote_data_source.dart';
import 'package:workoutride/data/repository/workout_repository_impl.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/workout/workout_result.dart';
import 'package:workoutride/domain/model/workout/workout_result_draft.dart';
import 'package:workoutride/domain/model/workout/workout_summary.dart';

import 'workout_repository_impl_test.mocks.dart';

// 現状 WorkoutRepositoryImpl は RemoteDataSource への単純委譲。
// このテストは「委譲していること」を固定し、PR④（DTO→WorkoutResultDraft 変換の
// data 層への移設）の際に、変換ロジックを追記するホームとして機能する。
@GenerateMocks([WorkoutRemoteDataSource])
void main() {
  late MockWorkoutRemoteDataSource mockDataSource;
  late WorkoutRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockWorkoutRemoteDataSource();
    repository = WorkoutRepositoryImpl(mockDataSource);
  });

  final testSummary = WorkoutSummary(
    id: 1,
    name: 'test',
    totalDuration: 900,
    category: 'エンデュランス',
    createdAt: DateTime(2023),
    updatedAt: DateTime(2023),
  );

  final testBlocks = [
    WorkoutBlock(
      id: 1,
      workoutId: 1,
      blockType: 'ウォームアップ',
      targetFtpPercentage: 60,
      durationSeconds: 300,
      orderIndex: 1,
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023),
    ),
  ];

  final testResult = WorkoutResult(
    id: 1,
    workoutSummaryId: 1,
    startedAt: DateTime(2023),
    finishedAt: DateTime(2023),
    totalDurationSeconds: 900,
    status: 'completed',
    createdAt: DateTime(2023),
    updatedAt: DateTime(2023),
    workoutBlockResults: const [],
  );

  group('WorkoutRepositoryImpl', () {
    test('getWorkoutSummaries は DataSource に委譲する', () async {
      when(mockDataSource.getWorkoutSummaries())
          .thenAnswer((_) async => [testSummary]);

      final result = await repository.getWorkoutSummaries();

      expect(result, [testSummary]);
      verify(mockDataSource.getWorkoutSummaries()).called(1);
    });

    test('getWorkoutSummary は DataSource に委譲する', () async {
      when(mockDataSource.getWorkoutSummary(1))
          .thenAnswer((_) async => testSummary);

      final result = await repository.getWorkoutSummary(1);

      expect(result, testSummary);
      verify(mockDataSource.getWorkoutSummary(1)).called(1);
    });

    test('getWorkoutBlocks は DataSource に委譲する', () async {
      when(mockDataSource.getWorkoutBlocks(1))
          .thenAnswer((_) async => testBlocks);

      final result = await repository.getWorkoutBlocks(1);

      expect(result, testBlocks);
      verify(mockDataSource.getWorkoutBlocks(1)).called(1);
    });

    test('getWorkoutResults は DataSource に委譲する', () async {
      when(mockDataSource.getWorkoutResults())
          .thenAnswer((_) async => [testResult]);

      final result = await repository.getWorkoutResults();

      expect(result, [testResult]);
      verify(mockDataSource.getWorkoutResults()).called(1);
    });

    test('getWorkoutResult は DataSource に委譲する', () async {
      when(mockDataSource.getWorkoutResult(1))
          .thenAnswer((_) async => testResult);

      final result = await repository.getWorkoutResult(1);

      expect(result, testResult);
      verify(mockDataSource.getWorkoutResult(1)).called(1);
    });

    test('saveWorkoutResult は Draft を DTO へ変換して DataSource に渡す', () async {
      final draft = WorkoutResultDraft(
        workoutSummaryId: 1,
        startedAt: DateTime.utc(2023, 1, 1, 0, 0, 0),
        finishedAt: DateTime.utc(2023, 1, 1, 0, 15, 0),
        totalDurationSeconds: 900,
        averagePower: 180,
        maxPower: 250,
        averageCadence: 85,
        status: 'completed',
        blockResults: const [
          WorkoutBlockResultDraft(
            workoutBlockId: 10,
            averagePower: 150,
            maxPower: 200,
            averageCadence: 80,
            durationSeconds: 300,
          ),
        ],
      );
      when(mockDataSource.saveWorkoutResult(any))
          .thenAnswer((_) async => testResult);

      final result = await repository.saveWorkoutResult(draft);

      expect(result, testResult);
      final captured = verify(mockDataSource.saveWorkoutResult(captureAny))
          .captured
          .single as SaveWorkoutResultRequest;
      // DateTime は data 層で ISO8601(UTC) 文字列へ変換される
      expect(captured.toJson(), {
        'workout_summary_id': 1,
        'started_at': '2023-01-01T00:00:00.000Z',
        'finished_at': '2023-01-01T00:15:00.000Z',
        'total_duration_seconds': 900,
        'average_power': 180,
        'max_power': 250,
        'average_cadence': 85,
        'status': 'completed',
        'workout_block_results': [
          {
            'workout_block_id': 10,
            'average_power': 150,
            'max_power': 200,
            'average_cadence': 80,
            'duration_seconds': 300,
          },
        ],
      });
    });
  });
}
