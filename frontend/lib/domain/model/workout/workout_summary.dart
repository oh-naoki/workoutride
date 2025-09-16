import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_summary.freezed.dart';

@freezed
class WorkoutSummary with _$WorkoutSummary {
  const factory WorkoutSummary({
    required int id,
    required String name,
    required int totalDuration,
    required String category,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WorkoutSummary;
}
