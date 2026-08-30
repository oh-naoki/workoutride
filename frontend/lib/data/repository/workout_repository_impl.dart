import 'package:workoutride/data/remote/api/workout_api_client.dart';
import 'package:workoutride/data/remote/error/exception_mapper.dart';
import 'package:workoutride/data/remote/model/extensions.dart';
import 'package:workoutride/data/remote/model/save_workout_result_request.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/workout/workout_result.dart';
import 'package:workoutride/domain/model/workout/workout_result_draft.dart';
import 'package:workoutride/domain/model/workout/workout_summary.dart';
import 'package:workoutride/domain/repository/workout_repository.dart';

/// ApiClient を直接使い、DTO→ドメインの変換もここで行う。
///
/// 以前は間に WorkoutRemoteDataSource を挟んだ3段構成だったが、その層は
/// ApiClient を呼んで toDomain() するだけで、auth / user_profile の
/// Repository は同じことを2段でやっていた。段数を揃えるため統合した
/// （docs/architecture.md §7 E1）。
class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutApiClient _apiClient;

  WorkoutRepositoryImpl(this._apiClient);

  @override
  Future<List<WorkoutSummary>> getWorkoutSummaries() {
    return guardApiCall(() async {
      final summaries = await _apiClient.getWorkoutSummaries();
      return summaries.map((e) => e.toDomain()).toList();
    });
  }

  @override
  Future<WorkoutSummary> getWorkoutSummary(int id) {
    return guardApiCall(() async {
      final summary = await _apiClient.getWorkoutSummary(id);
      return summary.toDomain();
    });
  }

  @override
  Future<List<WorkoutBlock>> getWorkoutBlocks(int workoutSummaryId) {
    return guardApiCall(() async {
      final blocks = await _apiClient.getWorkoutBlocks(workoutSummaryId);
      return blocks.map((e) => e.toDomain()).toList();
    });
  }

  @override
  Future<List<WorkoutResult>> getWorkoutResults() {
    return guardApiCall(() async {
      final results = await _apiClient.getWorkoutResults();
      return results.map((e) => e.toDomain()).toList();
    });
  }

  @override
  Future<WorkoutResult> getWorkoutResult(int id) {
    return guardApiCall(() async {
      final result = await _apiClient.getWorkoutResult(id);
      return result.toDomain();
    });
  }

  @override
  Future<WorkoutResult> saveWorkoutResult(WorkoutResultDraft draft) {
    return guardApiCall(() async {
      final result =
          await _apiClient.saveWorkoutResult(_toRequest(draft).toJson());
      return result.toDomain();
    });
  }

  /// ドメインの Draft を API DTO へ変換する（ISO8601 文字列化を含む）。
  SaveWorkoutResultRequest _toRequest(WorkoutResultDraft draft) {
    return SaveWorkoutResultRequest(
      workoutSummaryId: draft.workoutSummaryId,
      startedAt: draft.startedAt.toUtc().toIso8601String(),
      finishedAt: draft.finishedAt?.toUtc().toIso8601String(),
      totalDurationSeconds: draft.totalDurationSeconds,
      averagePower: draft.averagePower,
      maxPower: draft.maxPower,
      averageCadence: draft.averageCadence,
      status: draft.status,
      workoutBlockResults: draft.blockResults
          .map(
            (b) => SaveWorkoutBlockResultRequest(
              workoutBlockId: b.workoutBlockId,
              averagePower: b.averagePower,
              maxPower: b.maxPower,
              averageCadence: b.averageCadence,
              durationSeconds: b.durationSeconds,
            ),
          )
          .toList(),
    );
  }
}
