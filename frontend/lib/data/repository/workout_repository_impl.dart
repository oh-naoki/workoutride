import 'package:workoutride/data/remote/error/exception_mapper.dart';
import 'package:workoutride/data/remote/model/save_workout_result_request.dart';
import 'package:workoutride/data/remote/workout_remote_data_source.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/workout/workout_result.dart';
import 'package:workoutride/domain/model/workout/workout_result_draft.dart';
import 'package:workoutride/domain/model/workout/workout_summary.dart';
import 'package:workoutride/domain/repository/workout_repository.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutRemoteDataSource _remoteDataSource;

  WorkoutRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<WorkoutSummary>> getWorkoutSummaries() {
    return guardApiCall(() => _remoteDataSource.getWorkoutSummaries());
  }

  @override
  Future<WorkoutSummary> getWorkoutSummary(int id) {
    return guardApiCall(() => _remoteDataSource.getWorkoutSummary(id));
  }

  @override
  Future<List<WorkoutBlock>> getWorkoutBlocks(int workoutSummaryId) {
    return guardApiCall(
      () => _remoteDataSource.getWorkoutBlocks(workoutSummaryId),
    );
  }

  @override
  Future<List<WorkoutResult>> getWorkoutResults() {
    return guardApiCall(() => _remoteDataSource.getWorkoutResults());
  }

  @override
  Future<WorkoutResult> getWorkoutResult(int id) {
    return guardApiCall(() => _remoteDataSource.getWorkoutResult(id));
  }

  @override
  Future<WorkoutResult> saveWorkoutResult(WorkoutResultDraft draft) {
    return guardApiCall(
      () => _remoteDataSource.saveWorkoutResult(_toRequest(draft)),
    );
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
