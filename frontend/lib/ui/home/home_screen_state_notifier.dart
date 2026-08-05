import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/error/app_exception.dart';
import 'package:workoutride/domain/model/workout/workout_summary.dart';
import 'package:workoutride/domain/repository/workout_repository.dart';
import 'package:workoutride/domain/usecase/auto_connect_ble_power_meter_use_case.dart';

part 'home_screen_state_notifier.freezed.dart';
part 'home_screen_state_notifier.g.dart';

@freezed
class HomeScreenUiState with _$HomeScreenUiState {
  const factory HomeScreenUiState({
    @Default([]) List<WorkoutSummary> workoutSummaries,
    @Default(false) bool isLoading,
    @Default(false) bool isConnectingBle,
    @Default(false) bool isBleConnected,
    String? errorMessage,
    String? bleErrorMessage,
  }) = _HomeScreenUiState;
}

@riverpod
class HomeScreenStateNotifier extends _$HomeScreenStateNotifier {
  late final WorkoutRepository _workoutRepository;
  late final AutoConnectBlePowerMeterUseCase _autoConnectBlePowerMeterUseCase;

  @override
  HomeScreenUiState build() {
    state = const HomeScreenUiState(isLoading: true);
    _workoutRepository = ref.read(workoutRepositoryProvider);
    _autoConnectBlePowerMeterUseCase =
        ref.read(autoConnectBlePowerMeterUseCaseProvider);

    _fetchWorkoutSummaries();
    _autoConnectBleDevice();

    return state;
  }

  Future<void> _fetchWorkoutSummaries() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final summaries = await _workoutRepository.getWorkoutSummaries();
      state = state.copyWith(
        workoutSummaries: summaries,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppException.messageFor(e),
      );
    }
  }

  Future<void> _autoConnectBleDevice() async {
    try {
      state = state.copyWith(isConnectingBle: true, bleErrorMessage: null);

      final isConnected = await _autoConnectBlePowerMeterUseCase.call();

      state = state.copyWith(
        isConnectingBle: false,
        isBleConnected: isConnected,
        bleErrorMessage: isConnected ? null : '自動接続に失敗しました',
      );
    } catch (e) {
      state = state.copyWith(
        isConnectingBle: false,
        isBleConnected: false,
        bleErrorMessage: 'BLE接続エラー: $e',
      );
    }
  }

  Future<void> refreshWorkoutSummaries() async {
    await _fetchWorkoutSummaries();
  }

  Future<void> retryBleConnection() async {
    await _autoConnectBleDevice();
  }

  Future<void> cancelBleConnection() async {
    await _autoConnectBlePowerMeterUseCase.cancelConnection();
    state = state.copyWith(
      isConnectingBle: false,
      isBleConnected: false,
      bleErrorMessage: null,
    );
  }
}
