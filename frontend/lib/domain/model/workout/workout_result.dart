import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:workoutride/domain/model/workout/workout_block_result.dart';

part 'workout_result.freezed.dart';

@freezed
class WorkoutResult with _$WorkoutResult {
  const factory WorkoutResult({
    required int id,
    required int workoutSummaryId,
    required DateTime startedAt,
    DateTime? finishedAt,
    required int totalDurationSeconds,
    int? averagePower,
    int? maxPower,
    int? averageCadence,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<WorkoutBlockResult> workoutBlockResults,
  }) = _WorkoutResult;
}
