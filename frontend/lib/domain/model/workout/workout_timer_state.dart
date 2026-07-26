import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_timer_state.freezed.dart';

@freezed
class WorkoutTimerState with _$WorkoutTimerState {
  const factory WorkoutTimerState({
    @Default(0) int elapsedSeconds,
    @Default(false) bool isRunning,
  }) = _WorkoutTimerState;
}
