import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/workout/workout_result_draft.dart';

/// ワークアウト中のパワー/ケイデンス計測値を蓄積し、
/// 保存用の [WorkoutResultDraft] を組み立てる純粋なドメインサービス。
///
/// Riverpod や Flutter に依存しないため単体テストが容易。ViewModel
/// （WorkoutScreenStateNotifier）から集計ロジックを切り出したもの。
class WorkoutResultRecorder {
  final List<WorkoutBlock> _blocks;
  final DateTime _startedAt;

  int _overallMaxPower = 0;
  final List<int> _allPowerReadings = [];
  final List<int> _allCadenceReadings = [];
  // ブロックごとの記録
  final List<List<int>> _blockPowerReadings;
  final List<List<int>> _blockCadenceReadings;
  final List<int> _blockMaxPowers;

  WorkoutResultRecorder({
    required List<WorkoutBlock> blocks,
    required DateTime startedAt,
  })  : _blocks = blocks,
        _startedAt = startedAt,
        _blockPowerReadings = List.generate(blocks.length, (_) => <int>[]),
        _blockCadenceReadings = List.generate(blocks.length, (_) => <int>[]),
        _blockMaxPowers = List.filled(blocks.length, 0, growable: true);

  /// 1件の計測値を、その時点の [blockIndex]（現在ブロック）に紐づけて記録する。
  /// power / cadence が 0 のものは無効値として集計対象から除外する。
  void record({
    required int power,
    required int cadence,
    required int blockIndex,
  }) {
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
    if (blockIndex >= 0 && blockIndex < _blockPowerReadings.length) {
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
  }

  /// 蓄積した計測値から保存用 Draft を組み立てる。
  ///
  /// [status] が 'abandoned' の場合、[currentBlockIndex] より後ろのブロックは
  /// 結果に含めない。[currentBlockIndex] のブロック時間は、経過時間から
  /// それ以前のブロックの合計時間を引いて算出する。
  WorkoutResultDraft buildDraft({
    required String status,
    required int currentBlockIndex,
    required int elapsedSeconds,
    required DateTime finishedAt,
  }) {
    final averagePower = _average(_allPowerReadings);
    final averageCadence = _average(_allCadenceReadings);

    final blockResults = <WorkoutBlockResultDraft>[];
    for (var i = 0; i < _blocks.length; i++) {
      if (i > currentBlockIndex && status == 'abandoned') break;

      final blockPowers =
          _blockPowerReadings.length > i ? _blockPowerReadings[i] : <int>[];
      final blockCadences =
          _blockCadenceReadings.length > i ? _blockCadenceReadings[i] : <int>[];
      final blockMaxPower =
          _blockMaxPowers.length > i ? _blockMaxPowers[i] : null;

      // 実際に経過したブロック時間を計算
      int blockDuration;
      if (i < currentBlockIndex) {
        blockDuration = _blocks[i].durationSeconds;
      } else if (i == currentBlockIndex) {
        var previousBlocksTime = 0;
        for (var j = 0; j < i; j++) {
          previousBlocksTime += _blocks[j].durationSeconds;
        }
        blockDuration = elapsedSeconds - previousBlocksTime;
        if (blockDuration < 0) blockDuration = 0;
      } else {
        blockDuration = 0;
      }

      blockResults.add(WorkoutBlockResultDraft(
        workoutBlockId: _blocks[i].id,
        averagePower: _average(blockPowers),
        maxPower:
            blockMaxPower != null && blockMaxPower > 0 ? blockMaxPower : null,
        averageCadence: _average(blockCadences),
        durationSeconds: blockDuration,
      ));
    }

    return WorkoutResultDraft(
      workoutSummaryId: _blocks.first.workoutId,
      startedAt: _startedAt,
      finishedAt: finishedAt,
      totalDurationSeconds: elapsedSeconds,
      averagePower: averagePower,
      maxPower: _overallMaxPower > 0 ? _overallMaxPower : null,
      averageCadence: averageCadence,
      status: status,
      blockResults: blockResults,
    );
  }

  /// 空なら null、そうでなければ四捨五入した平均値。
  static int? _average(List<int> values) {
    if (values.isEmpty) return null;
    return (values.reduce((a, b) => a + b) / values.length).round();
  }
}
