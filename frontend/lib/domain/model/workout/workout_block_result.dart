import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_block_result.freezed.dart';

@freezed
class WorkoutBlockResult with _$WorkoutBlockResult {
  const factory WorkoutBlockResult({
    required int id,
    required int workoutResultId,
    required int workoutBlockId,
    int? averagePower,
    int? maxPower,
    int? averageCadence,
    required int durationSeconds,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WorkoutBlockResult;
}
