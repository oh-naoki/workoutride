import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/power_alert_message.dart';
import 'package:workoutride/domain/repository/user_profile_repository.dart';
import 'package:workoutride/domain/repository/workout_repository.dart';
import 'package:workoutride/domain/service/workout_result_recorder.dart';
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
  late final WorkoutRepository _workoutRepository;
  late final UserProfileRepository _userProfileRepository;
  late final GetCalculatedPowerMeterDataUseCase _getPowerMeterDataUseCase;
  late final ManageWorkoutUseCase _manageWorkoutUseCase;
  double? _userWeight;
  int? _userFtp;
  StreamSubscription? _workoutSubscription;
  StreamSubscription? _powerSubscription;
  Timer? _countdownTimer;
  Timer? _completionTimer;

  // ワークアウト結果の集計は WorkoutResultRecorder（純粋ドメインサービス）へ委譲。
  WorkoutResultRecorder? _recorder;
  int _lastBlockIndex = 0;

  @override
  WorkoutScreenUiState build(int workoutId) {
    _powerSubscription?.cancel();
    _workoutSubscription?.cancel();
    _countdownTimer?.cancel();

    _workoutRepository = ref.read(workoutRepositoryProvider);
    _userProfileRepository = ref.read(userProfileRepositoryProvider);
    _getPowerMeterDataUseCase =
        ref.read(getCalculatedPowerMeterDataUseCaseProvider);
    _manageWorkoutUseCase = ref.read(manageWorkoutUseCaseProvider);

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

    _lastBlockIndex = 0;
    _recorder = WorkoutResultRecorder(
      blocks: state.workoutBlocks,
      startedAt: DateTime.now(),
    );

    // ManageWorkoutUseCaseのストリームを購読し、UiStateへ反映
    _workoutSubscription =
        _manageWorkoutUseCase(state.workoutBlocks).listen((frame) {
      final timerState = frame.timer;
      final progressState = frame.progress;
      final alert = frame.alert;

      // ブロック切り替えを検出
      if (progressState.currentBlockIndex != _lastBlockIndex) {
        _lastBlockIndex = progressState.currentBlockIndex;
      }

      // 現在ブロックに応じてターゲットパワーを更新
      final nextTarget =
          (progressState.currentBlockIndex < state.workoutBlocks.length)
              ? state.workoutBlocks[progressState.currentBlockIndex]
                  .calculateTargetPower(_userFtp!)
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

      _recorder?.record(
        power: power,
        cadence: cadence,
        blockIndex: state.currentBlockIndex,
      );

      state = state.copyWith(
        power: power,
        cadence: cadence,
      );
    });
  }

  Future<void> _initializeWorkout(int workoutId) async {
    try {
      // FTPは UserProfileRepository から直接取得（ワークアウト前画面と同じ方法）
      final ftp = await _userProfileRepository.getFtp();
      _userFtp = ftp ?? 200;

      // 体重はUserProfileから取得（失敗してもFTP取得には影響しない）
      try {
        final userProfile = await _userProfileRepository.getUserProfile();
        _userWeight = userProfile?.weight ?? 60.0;
      } catch (_) {
        _userWeight = 60.0;
      }

      final blocks = await _workoutRepository.getWorkoutBlocks(workoutId);

      final maxTargetPercentage = blocks.fold(
          0,
          (max, block) => block.targetFtpPercentage > max
              ? block.targetFtpPercentage
              : max);
      final maxTargetWatts = (_userFtp! * maxTargetPercentage / 100).round();

      state = WorkoutScreenUiState(
        workoutBlocks: blocks,
        isLoading: false,
        maxPower: (maxTargetWatts * 1.5).toInt(),
        targetPower: blocks.isNotEmpty
            ? blocks.first.calculateTargetPower(_userFtp!)
            : 0,
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
    if (_recorder == null || state.workoutBlocks.isEmpty) return;
    if (state.isSavingResult || state.isResultSaved) return;

    state = state.copyWith(isSavingResult: true);

    try {
      final draft = _recorder!.buildDraft(
        status: status,
        currentBlockIndex: state.currentBlockIndex,
        elapsedSeconds: state.elapsedSeconds,
        finishedAt: DateTime.now(),
      );

      await _workoutRepository.saveWorkoutResult(draft);
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
        state =
            state.copyWith(completionCountdown: 0, shouldNavigateHome: true);
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
