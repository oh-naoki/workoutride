import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_block.freezed.dart';

@freezed
class WorkoutBlock with _$WorkoutBlock {
  const factory WorkoutBlock({
    required int id,
    required int workoutId,
    required int orderIndex,
    required int targetPower,
    required int duration,
    required String blockType,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WorkoutBlock;
}
