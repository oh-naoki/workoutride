import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/error/app_exception.dart';
import 'package:workoutride/domain/model/workout/workout_result.dart';
import 'package:workoutride/domain/repository/workout_repository.dart';

part 'history_screen_state_notifier.freezed.dart';
part 'history_screen_state_notifier.g.dart';

@freezed
class HistoryScreenUiState with _$HistoryScreenUiState {
  const factory HistoryScreenUiState({
    @Default([]) List<WorkoutResult> workoutResults,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _HistoryScreenUiState;
}

@riverpod
class HistoryScreenStateNotifier extends _$HistoryScreenStateNotifier {
  late final WorkoutRepository _workoutRepository;

  @override
  HistoryScreenUiState build() {
    state = const HistoryScreenUiState(isLoading: true);
    _workoutRepository = ref.read(workoutRepositoryProvider);
    _fetchWorkoutResults();
    return state;
  }

  Future<void> _fetchWorkoutResults() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final results = await _workoutRepository.getWorkoutResults();
      state = state.copyWith(
        workoutResults: results,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppException.messageFor(e),
      );
    }
  }

  Future<void> refreshWorkoutResults() async {
    await _fetchWorkoutResults();
  }
}
