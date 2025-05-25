import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_blocks_use_case.dart';

part 'workout_screen_state_notifier.freezed.dart';
part 'workout_screen_state_notifier.g.dart';

@freezed
class WorkoutScreenUiState with _$WorkoutScreenUiState {
  const factory WorkoutScreenUiState({
    @Default([]) List<WorkoutBlock> workoutBlocks,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _WorkoutScreenUiState;
}

@Riverpod(keepAlive: true)
class WorkoutScreenStateNotifier extends _$WorkoutScreenStateNotifier {
  late final GetWorkoutBlocksUseCase _getWorkoutBlocksUseCase;
  late int _workoutId;

  @override
  WorkoutScreenUiState build(int workoutId) {
    _workoutId = workoutId;
    state = const WorkoutScreenUiState(isLoading: true);
    _getWorkoutBlocksUseCase = ref.read(getWorkoutBlocksUseCaseProvider);
    _fetchWorkoutBlocks();
    return const WorkoutScreenUiState(isLoading: true);
  }

  Future<void> _fetchWorkoutBlocks() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final blocks = await _getWorkoutBlocksUseCase.call(_workoutId);
      state = state.copyWith(
        workoutBlocks: blocks,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshWorkoutBlocks() async {
    await _fetchWorkoutBlocks();
  }
}
