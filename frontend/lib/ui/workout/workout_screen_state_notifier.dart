import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_blocks_use_case.dart';
import 'package:workoutride/domain/usecase/get_calculated_power_meter_data_usecase.dart';

part 'workout_screen_state_notifier.freezed.dart';
part 'workout_screen_state_notifier.g.dart';

@freezed
class WorkoutScreenUiState with _$WorkoutScreenUiState {
  const factory WorkoutScreenUiState({
    @Default([]) List<WorkoutBlock> workoutBlocks,
    @Default(false) bool isLoading,
    @Default(0) int power,
    @Default(0) int cadence,
    @Default(0) int maxPower,
    @Default(0) int targetPower,
    String? errorMessage,
  }) = _WorkoutScreenUiState;
}

@Riverpod(keepAlive: true)
class WorkoutScreenStateNotifier extends _$WorkoutScreenStateNotifier {
  late final GetWorkoutBlocksUseCase _getWorkoutBlocksUseCase;
  late final GetCalculatedPowerMeterDataUseCase _getPowerMeterDataUseCase;
  late int _workoutId;

  @override
  WorkoutScreenUiState build(int workoutId) {
    _workoutId = workoutId;
    state = const WorkoutScreenUiState(isLoading: true);
    _getWorkoutBlocksUseCase = ref.read(getWorkoutBlocksUseCaseProvider);
    _getPowerMeterDataUseCase = ref.watch(getCalculatedPowerMeterDataUseCaseProvider);
    _fetchWorkoutBlocks();
    _startListeningToPowerMeterData();

    ref.onDispose(() {
      _cancelCurrentListener();
    });

    return const WorkoutScreenUiState(isLoading: true);
  }

  void _startListeningToPowerMeterData() {
    _cancelCurrentListener();
    
    _currentListener = _getPowerMeterDataUseCase().listen((powerMeterData) {
      state = state.copyWith(
        power: powerMeterData.power,
        cadence: powerMeterData.cadence,
      );
    });
  }

  StreamSubscription? _currentListener;

  void _cancelCurrentListener() {
    _currentListener?.cancel();
    _currentListener = null;
  }

  Future<void> _fetchWorkoutBlocks() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final blocks = await _getWorkoutBlocksUseCase.call(_workoutId);
      
      // 最大パワー値を計算（全ブロックの中で最大のtargetPowerを取得）
      final maxTargetPower = blocks.fold(0, (max, block) => block.targetPower > max ? block.targetPower : max);
      
      state = state.copyWith(
        workoutBlocks: blocks,
        isLoading: false,
        maxPower: (maxTargetPower * 1.5).toInt(), // 最大値の1.5倍を設定
        targetPower: blocks.isNotEmpty ? blocks.first.targetPower : 0, // 現在のブロックのターゲットパワー
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
