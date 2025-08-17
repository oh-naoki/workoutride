import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/power_alert_message.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_blocks_use_case.dart';
import 'package:workoutride/domain/usecase/get_calculated_power_meter_data_usecase.dart';
import 'package:workoutride/domain/usecase/workout/manage_workout_use_case.dart';
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

  @override
  WorkoutScreenUiState build(int workoutId) {
    // 既存のサブスクリプションをキャンセル
    _powerSubscription?.cancel();
    _workoutSubscription?.cancel();

    _getWorkoutBlocksUseCase = ref.read(getWorkoutBlocksUseCaseProvider);
    _getPowerMeterDataUseCase = ref.read(getCalculatedPowerMeterDataUseCaseProvider);
    _getUserProfileUseCase = ref.read(getUserProfileUseCaseProvider);

    ref.onDispose(() {
      _powerSubscription?.cancel();
      _workoutSubscription?.cancel();
    });

    _initializeWorkout(workoutId);
    return const WorkoutScreenUiState(isLoading: true);
  }

  Future<void> _initializeWorkout(int workoutId) async {
    print('_initializeWorkout: ワークアウト初期化を開始: workoutId = $workoutId');
    
    try {
      // ユーザープロファイルを取得
      final userProfile = await _getUserProfileUseCase();
      _userWeight = userProfile?.weight ?? 60.0; // デフォルト60kg
      _userFtp = userProfile?.ftp ?? 200; // デフォルト200W
      
      print('_initializeWorkout: ユーザープロファイル取得完了 - weight: $_userWeight, ftp: $_userFtp');
      
      final blocks = await _getWorkoutBlocksUseCase.call(workoutId);
      
      print('_initializeWorkout: ワークアウトブロック取得完了 - ブロック数: ${blocks.length}');
      
      // 最大パワー値を計算（全ブロックの中で最大のtargetFtpPercentageを取得）
      final maxTargetPercentage = blocks.fold(0, (max, block) => block.targetFtpPercentage > max ? block.targetFtpPercentage : max);
      final maxTargetWatts = (_userFtp! * maxTargetPercentage / 100).round();
      
      print('_initializeWorkout: 最大パワー計算完了 - maxTargetPercentage: $maxTargetPercentage, maxTargetWatts: $maxTargetWatts');
      
      state = WorkoutScreenUiState(
        workoutBlocks: blocks,
        isLoading: false,
        maxPower: (maxTargetWatts * 1.5).toInt(), // 最大値の1.5倍を設定
        targetPower: blocks.isNotEmpty ? blocks.first.calculateTargetPower(_userFtp!) : 0,
        userWeight: _userWeight!,
        userFtp: _userFtp!,
      );

      print('_initializeWorkout: 初期状態を設定しました');

      // ワークアウトを開始
      _startWorkout(blocks);
      _startListeningToPowerMeterData();
      
      print('_initializeWorkout: ワークアウト初期化完了');
    } catch (e) {
      print('_initializeWorkout: エラーが発生しました: $e');
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
    
    print('_startWorkout: ワークアウトを開始します');
    print('_startWorkout: ブロック数: ${blocks.length}');
    
    // 基本的なワークアウト機能を復活
    // 現在のブロックインデックスを0に設定
    state = state.copyWith(
      currentBlockIndex: 0,
      elapsedSeconds: 0,
      isPaused: false,
    );
    
    print('_startWorkout: 初期状態を設定しました');
    
    // タイマーを開始（1秒ごとに更新）
    _workoutSubscription = Stream.periodic(const Duration(seconds: 1)).listen((_) {
      print('_startWorkout: タイマー更新 - 現在の状態: isPaused=${state.isPaused}, elapsedSeconds=${state.elapsedSeconds}');
      
      if (!state.isPaused) {
        final newElapsedSeconds = state.elapsedSeconds + 1;
        print('_startWorkout: 時間を更新: $newElapsedSeconds秒');
        
        // 現在のブロックの終了時間を計算
        var currentBlockEndTime = 0;
        for (var i = 0; i <= state.currentBlockIndex; i++) {
          if (i < blocks.length) {
            currentBlockEndTime += blocks[i].durationSeconds;
          }
        }
        
        print('_startWorkout: 現在のブロック終了時間: $currentBlockEndTime秒');
        
        // 次のブロックに移動するかチェック
        if (newElapsedSeconds >= currentBlockEndTime && 
            state.currentBlockIndex < blocks.length - 1) {
          print('_startWorkout: 次のブロックに移動します');
          state = state.copyWith(
            currentBlockIndex: state.currentBlockIndex + 1,
            elapsedSeconds: newElapsedSeconds,
            targetPower: blocks[state.currentBlockIndex + 1].calculateTargetPower(_userFtp!),
          );
        } else if (newElapsedSeconds >= currentBlockEndTime) {
          // ワークアウト完了
          print('_startWorkout: ワークアウト完了');
          state = state.copyWith(
            elapsedSeconds: newElapsedSeconds,
            isPaused: true,
          );
        } else {
          // 通常の時間経過
          print('_startWorkout: 通常の時間経過');
          state = state.copyWith(
            elapsedSeconds: newElapsedSeconds,
          );
        }
        
        print('_startWorkout: 状態更新完了 - elapsedSeconds: ${state.elapsedSeconds}, currentBlockIndex: ${state.currentBlockIndex}');
      } else {
        print('_startWorkout: 一時停止中なので時間を更新しません');
      }
    });
    
    print('_startWorkout: タイマーを開始しました');
  }

  void _startListeningToPowerMeterData() {
    _powerSubscription?.cancel();
    
    // パワーメーターデータの監視を開始
    _powerSubscription = _getPowerMeterDataUseCase().listen((powerMeterData) {
      state = state.copyWith(
        power: powerMeterData.power,
        cadence: powerMeterData.cadence,
      );
    });
  }

  void togglePauseResume() {
    // 一時停止・再開の切り替え
    state = state.copyWith(isPaused: !state.isPaused);
  }

  void stopWorkout() {
    _workoutSubscription?.cancel();
    _powerSubscription?.cancel();
    // TODO: ManageWorkoutUseCaseの使用方法を修正
    // 一時的にコメントアウト
    /*
    final notifier = ref.read(manageWorkoutUseCaseProvider(state.workoutBlocks).notifier);
    notifier.dispose();
    */
  }

  Future<void> refreshWorkoutBlocks() async {
    state = state.copyWith(isLoading: true);
    await _initializeWorkout(state.workoutBlocks.first.workoutId);
  }
}
