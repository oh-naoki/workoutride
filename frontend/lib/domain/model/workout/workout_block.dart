import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_block.freezed.dart';

@freezed
class WorkoutBlock with _$WorkoutBlock {
  const factory WorkoutBlock({
    required int id,
    required int workoutId,
    required int orderIndex,
    required int targetFtpPercentage,
    required int durationSeconds,
    required String blockType,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WorkoutBlock;

  const WorkoutBlock._();

  /// FTPから実際のターゲットパワーを計算
  int calculateTargetPower(int userFtp) {
    return (userFtp * targetFtpPercentage / 100).round();
  }
}
