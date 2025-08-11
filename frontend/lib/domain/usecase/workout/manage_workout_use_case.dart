import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/workout/workout_progress_state.dart';
import 'package:workoutride/domain/model/workout/workout_timer_state.dart';
import 'package:workoutride/domain/model/power_alert_message.dart';
import 'package:workoutride/domain/service/power_zone_analyzer.dart';
import 'package:workoutride/domain/usecase/get_calculated_power_meter_data_usecase.dart';
import 'package:workoutride/domain/usecase/user_profile/get_user_profile_use_case.dart';
import 'package:workoutride/di/providers.dart';

part 'manage_workout_use_case.g.dart';

@riverpod
ManageWorkoutUseCase manageWorkoutUseCase(ManageWorkoutUseCaseRef ref) {
  return ManageWorkoutUseCase(
    ref.watch(getCalculatedPowerMeterDataUseCaseProvider),
    ref.watch(powerZoneAnalyzerProvider),
    ref.watch(getUserProfileUseCaseProvider),
  );
}

class ManageWorkoutUseCase {
  final GetCalculatedPowerMeterDataUseCase _getPowerMeterDataUseCase;
  final PowerZoneAnalyzer _powerZoneAnalyzer;
  final GetUserProfileUseCase _getUserProfileUseCase;
  Timer? _timer;
  bool _isPaused = false;
  StreamController<(WorkoutTimerState, WorkoutProgressState, PowerAlertMessage?)>? _controller;
  double? _userWeight;

  ManageWorkoutUseCase(
    this._getPowerMeterDataUseCase,
    this._powerZoneAnalyzer,
    this._getUserProfileUseCase,
  );

  Stream<(WorkoutTimerState, WorkoutProgressState, PowerAlertMessage?)> call(List<WorkoutBlock> blocks) async* {
    // 前回の状態をリセット
    _timer?.cancel();
    _controller?.close();
    _isPaused = false;
    
    // 体重を取得
    final userProfile = await _getUserProfileUseCase();
    _userWeight = userProfile?.weight ?? 60.0;
    
    final totalSeconds = blocks.fold(0, (sum, block) => sum + block.durationSeconds);
    
    var currentProgressState = WorkoutProgressState(
      blocks: blocks,
      totalSeconds: totalSeconds,
    );

    var currentTimerState = const WorkoutTimerState();
    var currentPowerAlertMessage = null;

    final controller = StreamController<(WorkoutTimerState, WorkoutProgressState, PowerAlertMessage?)>();
    _controller = controller;
    
    // パワーメーターのデータストリームを購読
    final powerSubscription = _getPowerMeterDataUseCase().listen((powerData) {
      if (!controller.isClosed) {
        final currentBlock = currentProgressState.currentBlock;
        if (currentBlock != null) {
          PowerAlertMessage? alertMessage;
          
          final targetWatts = (currentBlock.targetPwr * _userWeight!).toInt();
          if (_powerZoneAnalyzer.isBelowTargetZone(powerData.power, targetWatts)) {
            alertMessage = PowerAlertMessage.powerTooLow;
          } else if (_powerZoneAnalyzer.isAboveTargetZone(powerData.power, targetWatts)) {
            alertMessage = PowerAlertMessage.powerTooHigh;
          }
          
          currentPowerAlertMessage = alertMessage;
          controller.add((currentTimerState, currentProgressState, currentPowerAlertMessage));
        }
      }
    });

    // タイマーを開始
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (controller.isClosed) {
        timer.cancel();
        return;
      }

      // 一時停止中の場合は時間を進めない
      if (_isPaused) {
        return;
      }

      final newElapsedSeconds = currentTimerState.elapsedSeconds + 1;
      
      // タイマー状態を更新
      currentTimerState = currentTimerState.copyWith(
        elapsedSeconds: newElapsedSeconds,
        isRunning: !_isPaused,
      );

      // 現在のブロックの終了時間を計算
      var currentBlockEndTime = 0;
      for (var i = 0; i <= currentProgressState.currentBlockIndex; i++) {
        currentBlockEndTime += blocks[i].durationSeconds;
      }

      // 進捗状態を更新
      if (newElapsedSeconds >= currentBlockEndTime && 
          currentProgressState.currentBlockIndex < blocks.length - 1) {
        // 次のブロックに移動
        currentProgressState = currentProgressState.copyWith(
          currentBlockIndex: currentProgressState.currentBlockIndex + 1,
          elapsedSeconds: newElapsedSeconds,
        );
      } else if (newElapsedSeconds >= totalSeconds) {
        // ワークアウト完了
        currentProgressState = currentProgressState.copyWith(
          isCompleted: true,
          elapsedSeconds: newElapsedSeconds,
        );
        timer.cancel();
        currentTimerState = currentTimerState.copyWith(isRunning: false);
      } else {
        // 通常の時間経過
        currentProgressState = currentProgressState.copyWith(
          elapsedSeconds: newElapsedSeconds,
        );
      }

      controller.add((currentTimerState, currentProgressState, currentPowerAlertMessage));
    });

    controller.onCancel = () {
      _timer?.cancel();
      powerSubscription.cancel();
    };

    yield* controller.stream;
  }

  void pauseWorkout() {
    _isPaused = true;
    // 現在の状態を一時停止状態で更新
    if (_controller != null && !_controller!.isClosed) {
      // 現在の状態を取得して一時停止状態に更新する必要がある場合はここで実装
    }
  }

  void resumeWorkout() {
    _isPaused = false;
  }

  bool get isPaused => _isPaused;

  void dispose() {
    _timer?.cancel();
    _controller?.close();
  }
} 