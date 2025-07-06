import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/workout/workout_progress_state.dart';
import 'package:workoutride/domain/model/workout/workout_timer_state.dart';
import 'package:workoutride/domain/service/power_zone_analyzer.dart';
import 'package:workoutride/domain/usecase/get_calculated_power_meter_data_usecase.dart';

part 'manage_workout_use_case.g.dart';

@riverpod
ManageWorkoutUseCase manageWorkoutUseCase(ManageWorkoutUseCaseRef ref) {
  return ManageWorkoutUseCase(
    ref.watch(getCalculatedPowerMeterDataUseCaseProvider),
    ref.watch(powerZoneAnalyzerProvider),
  );
}

class ManageWorkoutUseCase {
  final GetCalculatedPowerMeterDataUseCase _getPowerMeterDataUseCase;
  final PowerZoneAnalyzer _powerZoneAnalyzer;
  Timer? _timer;

  ManageWorkoutUseCase(
    this._getPowerMeterDataUseCase,
    this._powerZoneAnalyzer,
  );

  Stream<(WorkoutTimerState, WorkoutProgressState)> call(List<WorkoutBlock> blocks) {
    final totalSeconds = blocks.fold(0, (sum, block) => sum + block.durationSeconds);
    
    var currentProgressState = WorkoutProgressState(
      blocks: blocks,
      totalSeconds: totalSeconds,
    );

    var currentTimerState = const WorkoutTimerState();

    final controller = StreamController<(WorkoutTimerState, WorkoutProgressState)>();
    
    // パワーメーターのデータストリームを購読
    final powerSubscription = _getPowerMeterDataUseCase().listen((powerData) {
      if (!controller.isClosed) {
        final currentBlock = currentProgressState.currentBlock;
        if (currentBlock != null) {
          final isInZone = _powerZoneAnalyzer.isInTargetZone(
            powerData.power,
            currentBlock.targetPower,
          );
          // ここでパワーゾーンの判定に基づいて何かアクションを起こすことができます
        }
      }
    });

    // タイマーを開始
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (controller.isClosed) {
        timer.cancel();
        return;
      }

      final newElapsedSeconds = currentTimerState.elapsedSeconds + 1;
      
      // タイマー状態を更新
      currentTimerState = currentTimerState.copyWith(
        elapsedSeconds: newElapsedSeconds,
        isRunning: true,
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

      controller.add((currentTimerState, currentProgressState));
    });

    controller.onCancel = () {
      _timer?.cancel();
      powerSubscription.cancel();
    };

    return controller.stream;
  }

  void dispose() {
    _timer?.cancel();
  }
} 