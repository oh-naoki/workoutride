import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_id.freezed.dart';

@freezed
class WorkoutId with _$WorkoutId {
  const factory WorkoutId({
    required int id,
  }) = _WorkoutId;
}
