import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_result_draft.freezed.dart';

/// ワークアウト結果の保存リクエストを表すドメイン入力モデル。
///
/// ViewModel はこの Draft を組み立てて Repository に渡す。DTO
/// (SaveWorkoutResultRequest) への変換・シリアライズは data 層で行う。
/// 時刻は DateTime のまま保持し、ISO8601 文字列化は data 層の責務とする。
@freezed
class WorkoutResultDraft with _$WorkoutResultDraft {
  const factory WorkoutResultDraft({
    required int workoutSummaryId,
    required DateTime startedAt,
    DateTime? finishedAt,
    required int totalDurationSeconds,
    int? averagePower,
    int? maxPower,
    int? averageCadence,
    required String status,
    @Default([]) List<WorkoutBlockResultDraft> blockResults,
  }) = _WorkoutResultDraft;
}

@freezed
class WorkoutBlockResultDraft with _$WorkoutBlockResultDraft {
  const factory WorkoutBlockResultDraft({
    required int workoutBlockId,
    int? averagePower,
    int? maxPower,
    int? averageCadence,
    required int durationSeconds,
  }) = _WorkoutBlockResultDraft;
}
