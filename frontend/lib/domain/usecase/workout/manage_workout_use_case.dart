import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:workoutride/domain/model/power_alert_message.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/workout/workout_progress_state.dart';
import 'package:workoutride/domain/model/workout/workout_timer_state.dart';
import 'package:workoutride/domain/service/power_zone_analyzer.dart';
import 'package:workoutride/domain/usecase/get_calculated_power_meter_data_usecase.dart';
import 'package:workoutride/domain/usecase/user_profile/get_user_ftp_use_case.dart';

class WorkoutFrame {
  final WorkoutTimerState timer;
  final WorkoutProgressState progress;
  final PowerAlertMessage? alert;

  const WorkoutFrame({
    required this.timer,
    required this.progress,
    this.alert,
  });

  WorkoutFrame copyWith({
    WorkoutTimerState? timer,
    WorkoutProgressState? progress,
    PowerAlertMessage? alert,
  }) => WorkoutFrame(
    timer: timer ?? this.timer,
    progress: progress ?? this.progress,
    alert: alert ?? this.alert,
  );
}

class ManageWorkoutUseCase {
  final GetCalculatedPowerMeterDataUseCase _getCalculatedPowerMeterDataUseCase;
  final PowerZoneAnalyzer _powerZoneAnalyzer;
  final GetUserFtpUseCase _getUserFtpUseCase;

  final BehaviorSubject<bool> _paused$ = BehaviorSubject.seeded(false);

  ManageWorkoutUseCase(
    this._getCalculatedPowerMeterDataUseCase,
    this._powerZoneAnalyzer,
    this._getUserFtpUseCase,
  );

  Stream<WorkoutFrame> call(
    List<WorkoutBlock> blocks,
  ) async* {
    final ftp = await _getUserFtpUseCase.call();
    final userFtp = ftp ?? 200;

    final totalSeconds = blocks.fold<int>(0, (sum, block) => sum + block.durationSeconds);

    final power$ = _getCalculatedPowerMeterDataUseCase()
      .map((d) => d.power)
      .shareReplay(maxSize: 1);

    final tick$ = Stream<int>.periodic(const Duration(seconds: 1), (_) => 1);

    final activeTick$ = tick$
      .withLatestFrom<bool, (int tick, bool paused)>(_paused$, (t, p) => (t, p))
      .where((tp) => !tp.$2)
      .withLatestFrom<int, int>(power$, (tp, p) => p > 0 ? tp.$1 : 0)
      .where((t) => t > 0);

    const initialTimer = WorkoutTimerState(elapsedSeconds: 0, isRunning: true);
    const initialProgress = WorkoutProgressState(
      currentBlockIndex: 0,
      elapsedSeconds: 0,
      isCompleted: false,
    );

    final state$ = activeTick$.scan<(WorkoutTimerState, WorkoutProgressState)>((acc, _, __) {
      var (timer, progress) = acc;

      final newElapsed = timer.elapsedSeconds + 1;
      timer = timer.copyWith(elapsedSeconds: newElapsed, isRunning: true);

      var currentEnd = 0;
      for (var i = 0; i <= progress.currentBlockIndex; i++) {
        currentEnd += blocks[i].durationSeconds;
      }

      if (newElapsed >= totalSeconds) {
        progress = progress.copyWith(isCompleted: true, elapsedSeconds: newElapsed);
        timer = timer.copyWith(isRunning: false);
      } else if (newElapsed >= currentEnd && progress.currentBlockIndex < blocks.length - 1) {
        progress = progress.copyWith(
          currentBlockIndex: progress.currentBlockIndex + 1,
          elapsedSeconds: newElapsed,
        );
      } else {
        progress = progress.copyWith(elapsedSeconds: newElapsed);
      }

      return (timer, progress);
    }, (initialTimer, initialProgress));

    yield* Rx.combineLatest2<(WorkoutTimerState, WorkoutProgressState), int, WorkoutFrame>(
      state$,
      power$.startWith(0),
      (s, p) {
        final progress = s.$2;
        final currentBlock = progress.currentBlock;
        PowerAlertMessage? alert;
        if (currentBlock != null) {
          final target = currentBlock.calculateTargetPower(userFtp);
          if (_powerZoneAnalyzer.isBelowTargetZone(p, target)) {
            alert = PowerAlertMessage.powerTooLow;
          } else if (_powerZoneAnalyzer.isAboveTargetZone(p, target)) {
            alert = PowerAlertMessage.powerTooHigh;
          }
        }
        return WorkoutFrame(timer: s.$1, progress: s.$2, alert: alert);
      },
    );
  }

  void pauseWorkout() => _paused$.add(true);
  void resumeWorkout() => _paused$.add(false);
  bool get isPaused => _paused$.value;

  void dispose() {
    _paused$.close();
  }
} 