import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:workoutride/data/remote/api/workout_api_client.dart';
import 'package:workoutride/data/remote/model/workout_block_dto.dart';
import 'package:workoutride/data/remote/model/workout_result_dto.dart';
import 'package:workoutride/data/remote/model/workout_summary_dto.dart';
import 'package:workoutride/data/repository/workout_repository_impl.dart';
import 'package:workoutride/domain/model/workout/workout_result_draft.dart';

import 'workout_repository_impl_test.mocks.dart';

// WorkoutRemoteDataSource を廃止して ApiClient 直呼びの2段構成にしたため、
// モック対象を ApiClient に変更した。これにより DTO → ドメインモデルの変換も
// このテストの検証範囲に入る（以前は DataSource 側にあり未検証だった）。
@GenerateMocks([WorkoutApiClient])
void main() {
  late MockWorkoutApiClient mockApiClient;
  late WorkoutRepositoryImpl repository;

  setUp(() {
    mockApiClient = MockWorkoutApiClient();
    repository = WorkoutRepositoryImpl(mockApiClient);
  });

  const summaryDto = WorkoutSummaryDto(
    id: 1,
    name: 'test',
    total_duration: 900,
    category: 'エンデュランス',
    created_at: '2023-01-01T00:00:00.000Z',
    updated_at: '2023-01-01T00:00:00.000Z',
  );

  const blockDto = WorkoutBlockDto(
    id: 1,
    workout_summary_id: 1,
    order_index: 1,
    target_ftp_percentage: 60,
    duration: 300,
    block_type: 'ウォームアップ',
    created_at: '2023-01-01T00:00:00.000Z',
    updated_at: '2023-01-01T00:00:00.000Z',
  );

  const resultDto = WorkoutResultDto(
    id: 1,
    workout_summary_id: 1,
    started_at: '2023-01-01T00:00:00.000Z',
    finished_at: '2023-01-01T00:15:00.000Z',
    total_duration_seconds: 900,
    status: 'completed',
    created_at: '2023-01-01T00:00:00.000Z',
    updated_at: '2023-01-01T00:00:00.000Z',
  );

  group('WorkoutRepositoryImpl', () {
    test('getWorkoutSummaries は DTO をドメインモデルへ変換して返す', () async {
      when(mockApiClient.getWorkoutSummaries())
          .thenAnswer((_) async => [summaryDto]);

      final result = await repository.getWorkoutSummaries();

      expect(result.single.id, 1);
      expect(result.single.name, 'test');
      expect(result.single.totalDuration, 900);
      verify(mockApiClient.getWorkoutSummaries()).called(1);
    });

    test('getWorkoutSummary は DTO をドメインモデルへ変換して返す', () async {
      when(mockApiClient.getWorkoutSummary(1))
          .thenAnswer((_) async => summaryDto);

      final result = await repository.getWorkoutSummary(1);

      expect(result.id, 1);
      expect(result.category, 'エンデュランス');
      verify(mockApiClient.getWorkoutSummary(1)).called(1);
    });

    test('getWorkoutBlocks は DTO をドメインモデルへ変換して返す', () async {
      when(mockApiClient.getWorkoutBlocks(1))
          .thenAnswer((_) async => [blockDto]);

      final result = await repository.getWorkoutBlocks(1);

      // DTO の workout_summary_id はドメインでは workoutId になる
      expect(result.single.workoutId, 1);
      expect(result.single.durationSeconds, 300);
      expect(result.single.blockType, 'ウォームアップ');
      verify(mockApiClient.getWorkoutBlocks(1)).called(1);
    });

    test('getWorkoutResults は DTO をドメインモデルへ変換して返す', () async {
      when(mockApiClient.getWorkoutResults())
          .thenAnswer((_) async => [resultDto]);

      final result = await repository.getWorkoutResults();

      expect(result.single.id, 1);
      expect(result.single.status, 'completed');
      expect(result.single.totalDurationSeconds, 900);
      verify(mockApiClient.getWorkoutResults()).called(1);
    });

    test('getWorkoutResult は DTO をドメインモデルへ変換して返す', () async {
      when(mockApiClient.getWorkoutResult(1))
          .thenAnswer((_) async => resultDto);

      final result = await repository.getWorkoutResult(1);

      expect(result.id, 1);
      expect(result.startedAt, DateTime.parse('2023-01-01T00:00:00.000Z'));
      verify(mockApiClient.getWorkoutResult(1)).called(1);
    });

    test('saveWorkoutResult は Draft を API の JSON 形状へ変換して送る', () async {
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
      when(mockApiClient.saveWorkoutResult(any))
          .thenAnswer((_) async => resultDto);

      final result = await repository.saveWorkoutResult(draft);

      expect(result.id, 1);
      final captured = verify(mockApiClient.saveWorkoutResult(captureAny))
          .captured
          .single as Map<String, dynamic>;
      // DateTime は data 層で ISO8601(UTC) 文字列へ変換される
      expect(captured, {
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
