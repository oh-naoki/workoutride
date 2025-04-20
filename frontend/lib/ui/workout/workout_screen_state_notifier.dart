import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/workout/workout_summary.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_summaries_use_case.dart';

part 'workout_screen_state_notifier.freezed.dart';
part 'workout_screen_state_notifier.g.dart';

@freezed
class WorkoutScreenUiState with _$WorkoutScreenUiState {
  const factory WorkoutScreenUiState({
    @Default([]) List<WorkoutSummary> workoutSummaries,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _WorkoutScreenUiState;
}

@riverpod
class WorkoutScreenStateNotifier extends _$WorkoutScreenStateNotifier {
  late final GetWorkoutSummariesUseCase _getWorkoutSummariesUseCase;

  @override
  WorkoutScreenUiState build() {
    state = const WorkoutScreenUiState(isLoading: true);
    _getWorkoutSummariesUseCase = ref.read(getWorkoutSummariesUseCaseProvider);
    _fetchWorkoutSummaries();
    return state;
  }

  Future<void> _fetchWorkoutSummaries() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final summaries = await _getWorkoutSummariesUseCase.call();
      state = state.copyWith(
        workoutSummaries: summaries,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshWorkoutSummaries() async {
    await _fetchWorkoutSummaries();
  }
}
