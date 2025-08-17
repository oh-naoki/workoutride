import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/power_alert_message.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_blocks_use_case.dart';
import 'package:workoutride/domain/usecase/get_calculated_power_meter_data_usecase.dart';
import 'package:workoutride/domain/usecase/user_profile/get_user_profile_use_case.dart';

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
    @Default(false) bool isPaused,
    @Default(60.0) double userWeight,
    @Default(200) int userFtp,
    String? errorMessage,
    PowerAlertMessage? powerAlertMessage,
    @Default(true) bool isCountingDown,
    @Default(15) int countdownSeconds,
  }) = _WorkoutScreenUiState;
}

@riverpod
class WorkoutScreenStateNotifier extends _$WorkoutScreenStateNotifier {
  late final GetWorkoutBlocksUseCase _getWorkoutBlocksUseCase;
  late final GetCalculatedPowerMeterDataUseCase _getPowerMeterDataUseCase;
  late final GetUserProfileUseCase _getUserProfileUseCase;
  double? _userWeight;
  int? _userFtp;
  StreamSubscription? _workoutSubscription;
  StreamSubscription? _powerSubscription;
  Timer? _countdownTimer;
  
  @override
  WorkoutScreenUiState build(int workoutId) {
    // 既存のサブスクリプションをキャンセル
    _powerSubscription?.cancel();
    _workoutSubscription?.cancel();
    _countdownTimer?.cancel();

    _getWorkoutBlocksUseCase = ref.read(getWorkoutBlocksUseCaseProvider);
    _getPowerMeterDataUseCase = ref.read(getCalculatedPowerMeterDataUseCaseProvider);
    _getUserProfileUseCase = ref.read(getUserProfileUseCaseProvider);

    ref.onDispose(() {
      _powerSubscription?.cancel();
      _workoutSubscription?.cancel();
      _countdownTimer?.cancel();
    });

    _initializeWorkout(workoutId);
    return const WorkoutScreenUiState(isLoading: true);
  }

  void startCountdown() {
    if (!state.isCountingDown) return;
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdownSeconds <= 1) {
        timer.cancel();
        state = state.copyWith(
          isCountingDown: false,
          countdownSeconds: 15,
        );
        // カウントダウン完了時にワークアウトを開始
        _startWorkoutAfterCountdown();
      } else {
        state = state.copyWith(
          countdownSeconds: state.countdownSeconds - 1,
        );
      }
    });
  }

  void _startWorkoutAfterCountdown() {
    if (state.workoutBlocks.isNotEmpty) {
      _startWorkout(state.workoutBlocks);
      _startListeningToPowerMeterData();
    }
  }

  Future<void> _initializeWorkout(int workoutId) async {
    try {
      final userProfile = await _getUserProfileUseCase();
      _userWeight = userProfile?.weight ?? 60.0;
      _userFtp = userProfile?.ftp ?? 200;
      
      final blocks = await _getWorkoutBlocksUseCase.call(workoutId);
      
      final maxTargetPercentage = blocks.fold(0, (max, block) => block.targetFtpPercentage > max ? block.targetFtpPercentage : max);
      final maxTargetWatts = (_userFtp! * maxTargetPercentage / 100).round();
      
      state = WorkoutScreenUiState(
        workoutBlocks: blocks,
        isLoading: false,
        maxPower: (maxTargetWatts * 1.5).toInt(),
        targetPower: blocks.isNotEmpty ? blocks.first.calculateTargetPower(_userFtp!) : 0,
        userWeight: _userWeight!,
        userFtp: _userFtp!,
      );

      startCountdown();
    } catch (e) {
      state = WorkoutScreenUiState(
        isLoading: false,
        errorMessage: e.toString(),
        userWeight: _userWeight ?? 60.0,
        userFtp: _userFtp ?? 200,
      );
    }
  }

  void _startWorkout(List<WorkoutBlock> blocks) {
    _workoutSubscription?.cancel();
    
    state = state.copyWith(
      currentBlockIndex: 0,
      elapsedSeconds: 0,
      isPaused: false,
    );
    
    _workoutSubscription = Stream.periodic(const Duration(seconds: 1)).listen((_) {
      if (!state.isPaused) {
        final newElapsedSeconds = state.elapsedSeconds + 1;
        
        var currentBlockEndTime = 0;
        for (var i = 0; i <= state.currentBlockIndex; i++) {
          if (i < blocks.length) {
            currentBlockEndTime += blocks[i].durationSeconds;
          }
        }
        
        if (newElapsedSeconds >= currentBlockEndTime && 
            state.currentBlockIndex < blocks.length - 1) {
          state = state.copyWith(
            currentBlockIndex: state.currentBlockIndex + 1,
            elapsedSeconds: newElapsedSeconds,
            targetPower: blocks[state.currentBlockIndex + 1].calculateTargetPower(_userFtp!),
          );
        } else if (newElapsedSeconds >= currentBlockEndTime) {
          state = state.copyWith(
            elapsedSeconds: newElapsedSeconds,
            isPaused: true,
          );
        } else {
          state = state.copyWith(
            elapsedSeconds: newElapsedSeconds,
          );
        }
      }
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

  void togglePauseResume() {
    state = state.copyWith(isPaused: !state.isPaused);
  }

  void stopWorkout() {
    _workoutSubscription?.cancel();
    _powerSubscription?.cancel();
  }

  Future<void> refreshWorkoutBlocks() async {
    state = state.copyWith(isLoading: true);
    await _initializeWorkout(state.workoutBlocks.first.workoutId);
  }
}
