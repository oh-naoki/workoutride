import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/workout/workout_summary.dart';
import 'package:workoutride/domain/repository/workout_repository.dart';

part 'workout_detail_screen_state_notifier.freezed.dart';
part 'workout_detail_screen_state_notifier.g.dart';

@freezed
class WorkoutDetailScreenUiState with _$WorkoutDetailScreenUiState {
  const factory WorkoutDetailScreenUiState({
    @Default([]) List<WorkoutBlock> workoutBlocks,
    @Default(null) WorkoutSummary? workoutSummary,
    @Default(false) bool isLoading,
    @Default(null) String? errorMessage,
    @Default(null) double? userWeight,
    // 生の FTP。null は「未設定」を意味し、View 側でデフォルト200W扱い＋警告表示する。
    @Default(null) int? userFtp,
  }) = _WorkoutDetailScreenUiState;
}

@riverpod
class WorkoutDetailScreenStateNotifier
    extends _$WorkoutDetailScreenStateNotifier {
  late final WorkoutRepository _workoutRepository;

  @override
  WorkoutDetailScreenUiState build(int workoutId) {
    state = const WorkoutDetailScreenUiState(isLoading: true);
    _workoutRepository = ref.read(workoutRepositoryProvider);
    _fetchWorkoutDetail(workoutId);
    _loadUserWeight();
    _loadUserFtp();
    return state;
  }

  Future<void> _loadUserFtp() async {
    try {
      final ftp = await ref.read(userProfileRepositoryProvider).getFtp();
      // ftp が null（未設定）のときは state.userFtp を null のまま残す。
      if (ftp != null) {
        state = state.copyWith(userFtp: ftp);
      }
    } catch (_) {
      // 取得失敗時は未設定扱い（View がデフォルト200W＋警告を表示）。
    }
  }

  Future<void> _fetchWorkoutDetail(int workoutId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final results = await Future.wait([
        _workoutRepository.getWorkoutSummary(workoutId),
        _workoutRepository.getWorkoutBlocks(workoutId),
      ]);
      state = state.copyWith(
        workoutSummary: results[0] as WorkoutSummary,
        workoutBlocks: results[1] as List<WorkoutBlock>,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _loadUserWeight() async {
    try {
      final profile =
          await ref.read(userProfileRepositoryProvider).getUserProfile();

      state = state.copyWith(
        userWeight: profile?.weight ?? 60.0,
      );
    } catch (e) {
      state = state.copyWith(
        userWeight: 60.0,
      );
    }
  }

  Future<void> refreshWorkoutBlocks(int workoutId) async {
    await _fetchWorkoutDetail(workoutId);
  }

  void reloadUserWeight() {
    _loadUserWeight();
  }
}
