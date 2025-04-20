import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_blocks_use_case.dart';

part 'workout_detail_screen_state_notifier.freezed.dart';
part 'workout_detail_screen_state_notifier.g.dart';

@freezed
class WorkoutDetailScreenUiState with _$WorkoutDetailScreenUiState {
  const factory WorkoutDetailScreenUiState({
    @Default([]) List<WorkoutBlock> workoutBlocks,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _WorkoutDetailScreenUiState;
}

@riverpod
class WorkoutDetailScreenStateNotifier extends _$WorkoutDetailScreenStateNotifier {
  late final GetWorkoutBlocksUseCase _getWorkoutBlocksUseCase;
  
  @override
  WorkoutDetailScreenUiState build(int workoutId) {
    state = const WorkoutDetailScreenUiState(isLoading: true);
    _getWorkoutBlocksUseCase = ref.read(getWorkoutBlocksUseCaseProvider);
    _fetchWorkoutBlocks(workoutId);
    return state;
  }

  Future<void> _fetchWorkoutBlocks(int workoutId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final blocks = await _getWorkoutBlocksUseCase.call(workoutId);
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

  Future<void> refreshWorkoutBlocks(int workoutId) async {
    await _fetchWorkoutBlocks(workoutId);
  }
}
