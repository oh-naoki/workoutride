import 'dart:async';

import 'package:workoutride/domain/model/power_alert_message.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/workout/workout_progress_state.dart';
import 'package:workoutride/domain/model/workout/workout_timer_state.dart';
import 'package:workoutride/domain/service/power_zone_analyzer.dart';
import 'package:workoutride/domain/usecase/get_calculated_power_meter_data_usecase.dart';
import 'package:workoutride/domain/usecase/user_profile/get_user_profile_use_case.dart';

class ManageWorkoutUseCase {
  final GetCalculatedPowerMeterDataUseCase _getCalculatedPowerMeterDataUseCase;
  final PowerZoneAnalyzer _powerZoneAnalyzer;
  final GetUserProfileUseCase _getUserProfileUseCase;
  
  Timer? _timer;
  StreamController<(WorkoutTimerState, WorkoutProgressState, PowerAlertMessage?)>? _controller;
  bool _isPaused = false;
  double? _userWeight;
  int? _userFtp;

  ManageWorkoutUseCase(
    this._getCalculatedPowerMeterDataUseCase,
    this._powerZoneAnalyzer,
    this._getUserProfileUseCase,
  );

  Stream<(WorkoutTimerState, WorkoutProgressState, PowerAlertMessage?)> call(
    List<WorkoutBlock> blocks,
  ) async* {
    // ユーザープロファイルを取得
    final userProfile = await _getUserProfileUseCase.call();
    _userWeight = userProfile?.weight ?? 60.0;
    _userFtp = userProfile?.ftp ?? 200;

    final totalSeconds = blocks.fold<int>(0, (sum, block) => sum + block.durationSeconds);
    
    // 初期状態
    var currentTimerState = WorkoutTimerState(
      elapsedSeconds: 0,
      isRunning: true,
    );
    
    var currentProgressState = WorkoutProgressState(
      currentBlockIndex: 0,
      elapsedSeconds: 0,
      isCompleted: false,
    );
    
    PowerAlertMessage? currentPowerAlertMessage = null;
    
    _controller = StreamController<(WorkoutTimerState, WorkoutProgressState, PowerAlertMessage?)>();
    
    // パワーメーターのデータストリームを購読
    final powerSubscription = _getCalculatedPowerMeterDataUseCase().listen((powerData) {
      if (!_controller!.isClosed) {
        final currentBlock = currentProgressState.currentBlock;
        if (currentBlock != null) {
          PowerAlertMessage? alertMessage;
          
          final targetWatts = currentBlock.calculateTargetPower(_userFtp!);
          if (_powerZoneAnalyzer.isBelowTargetZone(powerData.power, targetWatts)) {
            alertMessage = PowerAlertMessage.powerTooLow;
          } else if (_powerZoneAnalyzer.isAboveTargetZone(powerData.power, targetWatts)) {
            alertMessage = PowerAlertMessage.powerTooHigh;
          }
          
          currentPowerAlertMessage = alertMessage;
          _controller!.add((currentTimerState, currentProgressState, currentPowerAlertMessage));
        }
      }
    });

    // タイマーを開始
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_controller!.isClosed) {
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

      _controller!.add((currentTimerState, currentProgressState, currentPowerAlertMessage));
    });

    _controller!.onCancel = () {
      _timer?.cancel();
      powerSubscription.cancel();
    };

    yield* _controller!.stream;
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