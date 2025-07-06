import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/di/providers.dart' hide manageWorkoutUseCaseProvider;
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_blocks_use_case.dart';
import 'package:workoutride/domain/usecase/get_calculated_power_meter_data_usecase.dart';
import 'package:workoutride/domain/usecase/workout/manage_workout_use_case.dart';

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
    @Default(0) int currentBlockIndex,
    @Default(0) int elapsedSeconds,
    String? errorMessage,
  }) = _WorkoutScreenUiState;
}

@Riverpod(keepAlive: true)
class WorkoutScreenStateNotifier extends _$WorkoutScreenStateNotifier {
  late final GetWorkoutBlocksUseCase _getWorkoutBlocksUseCase;
  late final GetCalculatedPowerMeterDataUseCase _getPowerMeterDataUseCase;
  late final ManageWorkoutUseCase _manageWorkoutUseCase;
  StreamSubscription? _workoutSubscription;
  StreamSubscription? _powerSubscription;

  @override
  WorkoutScreenUiState build(int workoutId) {
    _getWorkoutBlocksUseCase = ref.read(getWorkoutBlocksUseCaseProvider);
    _getPowerMeterDataUseCase = ref.read(getCalculatedPowerMeterDataUseCaseProvider);
    _manageWorkoutUseCase = ref.read(manageWorkoutUseCaseProvider);

    ref.onDispose(() {
      _powerSubscription?.cancel();
      _workoutSubscription?.cancel();
    });

    _initializeWorkout(workoutId);
    return const WorkoutScreenUiState(isLoading: true);
  }

  Future<void> _initializeWorkout(int workoutId) async {
    try {
      final blocks = await _getWorkoutBlocksUseCase.call(workoutId);
      
      // 最大パワー値を計算（全ブロックの中で最大のtargetPowerを取得）
      final maxTargetPower = blocks.fold(0, (max, block) => block.targetPower > max ? block.targetPower : max);
      
      state = WorkoutScreenUiState(
        workoutBlocks: blocks,
        isLoading: false,
        maxPower: (maxTargetPower * 1.5).toInt(), // 最大値の1.5倍を設定
        targetPower: blocks.isNotEmpty ? blocks.first.targetPower : 0, // 現在のブロックのターゲットパワー
      );

      // ワークアウトを開始
      _startWorkout(blocks);
      _startListeningToPowerMeterData();
    } catch (e) {
      state = WorkoutScreenUiState(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void _startWorkout(List<WorkoutBlock> blocks) {
    _workoutSubscription?.cancel();
    _workoutSubscription = _manageWorkoutUseCase(blocks).listen((workoutState) {
      final (timerState, progressState) = workoutState;
      state = state.copyWith(
        elapsedSeconds: timerState.elapsedSeconds,
        currentBlockIndex: progressState.currentBlockIndex,
        targetPower: progressState.currentBlock?.targetPower ?? 0,
      );
    });
  }

  void _startListeningToPowerMeterData() {
    _powerSubscription?.cancel();
    
    _powerSubscription = _getPowerMeterDataUseCase().listen((powerMeterData) {
      state = state.copyWith(
        power: powerMeterData.power,
        cadence: powerMeterData.cadence,
      );
    });
  }

  Future<void> refreshWorkoutBlocks() async {
    state = state.copyWith(isLoading: true);
    await _initializeWorkout(state.workoutBlocks.first.workoutId);
  }
}
