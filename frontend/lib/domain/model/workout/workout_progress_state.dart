import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';

part 'workout_progress_state.freezed.dart';

@freezed
class WorkoutProgressState with _$WorkoutProgressState {
  const factory WorkoutProgressState({
    @Default([]) List<WorkoutBlock> blocks,
    @Default(0) int currentBlockIndex,
    @Default(0) int elapsedSeconds,
    @Default(0) int totalSeconds,
    @Default(false) bool isCompleted,
  }) = _WorkoutProgressState;

  const WorkoutProgressState._();

  WorkoutBlock? get currentBlock =>
      blocks.isNotEmpty && currentBlockIndex < blocks.length
          ? blocks[currentBlockIndex]
          : null;

  int get remainingSeconds => totalSeconds - elapsedSeconds;
}
