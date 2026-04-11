import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/data/remote/model/save_workout_result_request.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/power_alert_message.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_blocks_use_case.dart';
import 'package:workoutride/domain/usecase/get_calculated_power_meter_data_usecase.dart';
import 'package:workoutride/domain/usecase/user_profile/get_user_ftp_use_case.dart';
import 'package:workoutride/domain/usecase/user_profile/get_user_profile_use_case.dart';
import 'package:workoutride/domain/usecase/workout/manage_workout_use_case.dart';
import 'package:workoutride/domain/usecase/workout/save_workout_result_use_case.dart';

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
    @Default(false) bool isSavingResult,
    @Default(false) bool isResultSaved,
    String? saveError,
    @Default(false) bool isCompleted,
    @Default(3) int completionCountdown,
    @Default(false) bool shouldNavigateHome,
  }) = _WorkoutScreenUiState;
}

@riverpod
class WorkoutScreenStateNotifier extends _$WorkoutScreenStateNotifier {
  late final GetWorkoutBlocksUseCase _getWorkoutBlocksUseCase;
  late final GetCalculatedPowerMeterDataUseCase _getPowerMeterDataUseCase;
  late final GetUserFtpUseCase _getUserFtpUseCase;
  late final GetUserProfileUseCase _getUserProfileUseCase;
  late final ManageWorkoutUseCase _manageWorkoutUseCase;
  late final SaveWorkoutResultUseCase _saveWorkoutResultUseCase;
  double? _userWeight;
  int? _userFtp;
  StreamSubscription? _workoutSubscription;
  StreamSubscription? _powerSubscription;
  Timer? _countdownTimer;
  Timer? _completionTimer;

  // ワークアウト結果の記録用
  DateTime? _workoutStartedAt;
  int _overallMaxPower = 0;
  final List<int> _allPowerReadings = [];
  final List<int> _allCadenceReadings = [];
  // ブロックごとの記録
  final List<List<int>> _blockPowerReadings = [];
  final List<List<int>> _blockCadenceReadings = [];
  final List<int> _blockMaxPowers = [];
  int _lastBlockIndex = 0;

  @override
  WorkoutScreenUiState build(int workoutId) {
    _powerSubscription?.cancel();
    _workoutSubscription?.cancel();
    _countdownTimer?.cancel();

    _getWorkoutBlocksUseCase = ref.read(getWorkoutBlocksUseCaseProvider);
    _getPowerMeterDataUseCase = ref.read(getCalculatedPowerMeterDataUseCaseProvider);
    _getUserFtpUseCase = ref.read(getUserFtpUseCaseProvider);
    _getUserProfileUseCase = ref.read(getUserProfileUseCaseProvider);
    _manageWorkoutUseCase = ref.read(manageWorkoutUseCaseProvider);
    _saveWorkoutResultUseCase = ref.read(saveWorkoutResultUseCaseProvider);

    ref.onDispose(() {
      _powerSubscription?.cancel();
      _workoutSubscription?.cancel();
      _countdownTimer?.cancel();
      _completionTimer?.cancel();
      _manageWorkoutUseCase.dispose();
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
        _startWorkoutAfterCountdown();
      } else {
        state = state.copyWith(
          countdownSeconds: state.countdownSeconds - 1,
        );
      }
    });
  }

  void _startWorkoutAfterCountdown() {
    if (state.workoutBlocks.isEmpty) return;

    _workoutStartedAt = DateTime.now();
    _lastBlockIndex = 0;
    _overallMaxPower = 0;
    _allPowerReadings.clear();
    _allCadenceReadings.clear();
    _blockPowerReadings.clear();
    _blockCadenceReadings.clear();
    _blockMaxPowers.clear();
    // ブロックごとの記録用リストを初期化
    for (var i = 0; i < state.workoutBlocks.length; i++) {
      _blockPowerReadings.add([]);
      _blockCadenceReadings.add([]);
      _blockMaxPowers.add(0);
    }

    // ManageWorkoutUseCaseのストリームを購読し、UiStateへ反映
    _workoutSubscription = _manageWorkoutUseCase(state.workoutBlocks).listen((frame) {
      final timerState = frame.timer;
      final progressState = frame.progress;
      final alert = frame.alert;

      // ブロック切り替えを検出
      if (progressState.currentBlockIndex != _lastBlockIndex) {
        _lastBlockIndex = progressState.currentBlockIndex;
      }

      // 現在ブロックに応じてターゲットパワーを更新
      final nextTarget = (progressState.currentBlockIndex < state.workoutBlocks.length)
          ? state.workoutBlocks[progressState.currentBlockIndex].calculateTargetPower(_userFtp!)
          : state.targetPower;

      state = state.copyWith(
        elapsedSeconds: timerState.elapsedSeconds,
        currentBlockIndex: progressState.currentBlockIndex,
        targetPower: nextTarget,
        powerAlertMessage: alert,
      );

      // ワークアウト完了時に自動保存
      if (progressState.isCompleted && !state.isCompleted) {
        state = state.copyWith(isCompleted: true);
        _saveResult('completed');
      }
    });

    // パワーメーターデータは従来通り購読 + 統計データを記録
    _powerSubscription = _getPowerMeterDataUseCase().listen((powerMeterData) {
      final power = powerMeterData.power;
      final cadence = powerMeterData.cadence;

      // 全体の記録
      if (power > 0) {
        _allPowerReadings.add(power);
        if (power > _overallMaxPower) {
          _overallMaxPower = power;
        }
      }
      if (cadence > 0) {
        _allCadenceReadings.add(cadence);
      }

      // 現在ブロックの記録
      final blockIndex = state.currentBlockIndex;
      if (blockIndex < _blockPowerReadings.length) {
        if (power > 0) {
          _blockPowerReadings[blockIndex].add(power);
          if (power > _blockMaxPowers[blockIndex]) {
            _blockMaxPowers[blockIndex] = power;
          }
        }
        if (cadence > 0) {
          _blockCadenceReadings[blockIndex].add(cadence);
        }
      }

      state = state.copyWith(
        power: power,
        cadence: cadence,
      );
    });
  }

  Future<void> _initializeWorkout(int workoutId) async {
    try {
      // FTPはGetUserFtpUseCaseで直接取得（ワークアウト前画面と同じ方法）
      final ftp = await _getUserFtpUseCase();
      _userFtp = ftp ?? 200;

      // 体重はUserProfileから取得（失敗してもFTP取得には影響しない）
      try {
        final userProfile = await _getUserProfileUseCase();
        _userWeight = userProfile?.weight ?? 60.0;
      } catch (_) {
        _userWeight = 60.0;
      }

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

  // 内部タイマーロジックはUseCaseへ移譲したため削除

  void togglePauseResume() {
    final shouldPause = !state.isPaused;
    if (shouldPause) {
      _manageWorkoutUseCase.pauseWorkout();
    } else {
      _manageWorkoutUseCase.resumeWorkout();
    }
    state = state.copyWith(isPaused: shouldPause);
  }

  Future<void> stopWorkout() async {
    _workoutSubscription?.cancel();
    _powerSubscription?.cancel();
    _manageWorkoutUseCase.dispose();
    await _saveResult('abandoned');
  }

  Future<void> _saveResult(String status) async {
    if (_workoutStartedAt == null || state.workoutBlocks.isEmpty) return;
    if (state.isSavingResult || state.isResultSaved) return;

    state = state.copyWith(isSavingResult: true);

    try {
      final now = DateTime.now();
      final averagePower = _allPowerReadings.isNotEmpty
          ? (_allPowerReadings.reduce((a, b) => a + b) / _allPowerReadings.length).round()
          : null;
      final averageCadence = _allCadenceReadings.isNotEmpty
          ? (_allCadenceReadings.reduce((a, b) => a + b) / _allCadenceReadings.length).round()
          : null;

      final blockResults = <SaveWorkoutBlockResultRequest>[];
      for (var i = 0; i < state.workoutBlocks.length; i++) {
        if (i > state.currentBlockIndex && status == 'abandoned') break;

        final blockPowers = _blockPowerReadings.length > i ? _blockPowerReadings[i] : <int>[];
        final blockCadences = _blockCadenceReadings.length > i ? _blockCadenceReadings[i] : <int>[];
        final blockMaxPower = _blockMaxPowers.length > i ? _blockMaxPowers[i] : null;

        // 実際に経過したブロック時間を計算
        int blockDuration;
        if (i < state.currentBlockIndex) {
          blockDuration = state.workoutBlocks[i].durationSeconds;
        } else if (i == state.currentBlockIndex) {
          int previousBlocksTime = 0;
          for (var j = 0; j < i; j++) {
            previousBlocksTime += state.workoutBlocks[j].durationSeconds;
          }
          blockDuration = state.elapsedSeconds - previousBlocksTime;
          if (blockDuration < 0) blockDuration = 0;
        } else {
          blockDuration = 0;
        }

        blockResults.add(SaveWorkoutBlockResultRequest(
          workoutBlockId: state.workoutBlocks[i].id,
          averagePower: blockPowers.isNotEmpty
              ? (blockPowers.reduce((a, b) => a + b) / blockPowers.length).round()
              : null,
          maxPower: blockMaxPower != null && blockMaxPower > 0 ? blockMaxPower : null,
          averageCadence: blockCadences.isNotEmpty
              ? (blockCadences.reduce((a, b) => a + b) / blockCadences.length).round()
              : null,
          durationSeconds: blockDuration,
        ));
      }

      final request = SaveWorkoutResultRequest(
        workoutSummaryId: state.workoutBlocks.first.workoutId,
        startedAt: _workoutStartedAt!.toUtc().toIso8601String(),
        finishedAt: now.toUtc().toIso8601String(),
        totalDurationSeconds: state.elapsedSeconds,
        averagePower: averagePower,
        maxPower: _overallMaxPower > 0 ? _overallMaxPower : null,
        averageCadence: averageCadence,
        status: status,
        workoutBlockResults: blockResults,
      );

      await _saveWorkoutResultUseCase.call(request);
      state = state.copyWith(isSavingResult: false, isResultSaved: true);
      if (status == 'completed') {
        _startCompletionCountdown();
      }
    } catch (e) {
      debugPrint('Failed to save workout result: $e');
      state = state.copyWith(
        isSavingResult: false,
        saveError: 'ワークアウトの保存に失敗しました。通信状況を確認してください。',
      );
    }
  }

  void _startCompletionCountdown() {
    state = state.copyWith(completionCountdown: 3);
    _completionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.completionCountdown - 1;
      if (remaining <= 0) {
        timer.cancel();
        state = state.copyWith(completionCountdown: 0, shouldNavigateHome: true);
      } else {
        state = state.copyWith(completionCountdown: remaining);
      }
    });
  }

  Future<void> refreshWorkoutBlocks() async {
    state = state.copyWith(isLoading: true);
    await _initializeWorkout(state.workoutBlocks.first.workoutId);
  }
}
