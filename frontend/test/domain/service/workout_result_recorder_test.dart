import 'package:flutter_test/flutter_test.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/service/workout_result_recorder.dart';

// ファット ViewModel から抽出した集計ロジックの単体テスト。
// PR④/⑥ まで保護テストが無かった _saveResult 相当の集計を、純粋クラスとして固定する。
void main() {
  WorkoutBlock block(int id, int order, int durationSeconds) => WorkoutBlock(
        id: id,
        workoutId: 100,
        blockType: 'block$order',
        targetFtpPercentage: 60,
        durationSeconds: durationSeconds,
        orderIndex: order,
        createdAt: DateTime(2023),
        updatedAt: DateTime(2023),
      );

  final startedAt = DateTime.utc(2023, 1, 1, 0, 0, 0);
  final finishedAt = DateTime.utc(2023, 1, 1, 0, 15, 0);

  group('WorkoutResultRecorder', () {
    test('completed: 全体・ブロックの平均/最大を集計し Draft を作る', () {
      final blocks = [block(1, 1, 300), block(2, 2, 600)];
      final recorder =
          WorkoutResultRecorder(blocks: blocks, startedAt: startedAt);

      // block 0 に 3件、block 1 に 2件記録
      recorder.record(power: 100, cadence: 80, blockIndex: 0);
      recorder.record(power: 200, cadence: 90, blockIndex: 0);
      recorder.record(power: 150, cadence: 100, blockIndex: 0);
      recorder.record(power: 300, cadence: 70, blockIndex: 1);
      recorder.record(power: 100, cadence: 90, blockIndex: 1);

      final draft = recorder.buildDraft(
        status: 'completed',
        currentBlockIndex: 1,
        elapsedSeconds: 900,
        finishedAt: finishedAt,
      );

      expect(draft.workoutSummaryId, 100);
      expect(draft.startedAt, startedAt);
      expect(draft.finishedAt, finishedAt);
      expect(draft.totalDurationSeconds, 900);
      expect(draft.status, 'completed');
      // 全体平均: (100+200+150+300+100)/5 = 170, 最大 300
      expect(draft.averagePower, 170);
      expect(draft.maxPower, 300);
      // 全体ケイデンス平均: (80+90+100+70+90)/5 = 86
      expect(draft.averageCadence, 86);

      expect(draft.blockResults.length, 2);
      final b0 = draft.blockResults[0];
      expect(b0.workoutBlockId, 1);
      expect(b0.averagePower, 150); // (100+200+150)/3
      expect(b0.maxPower, 200);
      expect(b0.averageCadence, 90); // (80+90+100)/3
      expect(b0.durationSeconds, 300); // 完了ブロックは満了時間
      final b1 = draft.blockResults[1];
      expect(b1.workoutBlockId, 2);
      expect(b1.averagePower, 200); // (300+100)/2
      expect(b1.maxPower, 300);
      // 現在ブロック時間 = elapsed(900) - 前ブロック合計(300) = 600
      expect(b1.durationSeconds, 600);
    });

    test('power/cadence が 0 の計測値は集計から除外される', () {
      final blocks = [block(1, 1, 300)];
      final recorder =
          WorkoutResultRecorder(blocks: blocks, startedAt: startedAt);

      recorder.record(power: 0, cadence: 0, blockIndex: 0);
      recorder.record(power: 200, cadence: 0, blockIndex: 0);
      recorder.record(power: 0, cadence: 90, blockIndex: 0);

      final draft = recorder.buildDraft(
        status: 'completed',
        currentBlockIndex: 0,
        elapsedSeconds: 300,
        finishedAt: finishedAt,
      );

      expect(draft.averagePower, 200); // 0 は除外され 200 のみ
      expect(draft.averageCadence, 90); // 0 は除外され 90 のみ
      expect(draft.maxPower, 200);
    });

    test('計測値ゼロ件のブロックは平均/最大が null', () {
      final blocks = [block(1, 1, 300)];
      final recorder =
          WorkoutResultRecorder(blocks: blocks, startedAt: startedAt);

      final draft = recorder.buildDraft(
        status: 'completed',
        currentBlockIndex: 0,
        elapsedSeconds: 300,
        finishedAt: finishedAt,
      );

      expect(draft.averagePower, isNull);
      expect(draft.averageCadence, isNull);
      expect(draft.maxPower, isNull);
      expect(draft.blockResults.single.averagePower, isNull);
      expect(draft.blockResults.single.maxPower, isNull);
      expect(draft.blockResults.single.averageCadence, isNull);
    });

    test('abandoned: 現在ブロックより後ろのブロックは結果に含めない', () {
      final blocks = [block(1, 1, 300), block(2, 2, 600), block(3, 3, 300)];
      final recorder =
          WorkoutResultRecorder(blocks: blocks, startedAt: startedAt);
      recorder.record(power: 150, cadence: 80, blockIndex: 0);
      recorder.record(power: 200, cadence: 85, blockIndex: 1);

      final draft = recorder.buildDraft(
        status: 'abandoned',
        currentBlockIndex: 1,
        elapsedSeconds: 500,
        finishedAt: finishedAt,
      );

      // block 2（index2）は含まれない
      expect(draft.blockResults.length, 2);
      expect(draft.blockResults[0].workoutBlockId, 1);
      expect(draft.blockResults[1].workoutBlockId, 2);
      // 現在ブロック(index1)の時間 = 500 - 300 = 200
      expect(draft.blockResults[1].durationSeconds, 200);
      expect(draft.status, 'abandoned');
    });

    test('現在ブロック時間が負になる場合は 0 にクランプする', () {
      final blocks = [block(1, 1, 300), block(2, 2, 600)];
      final recorder =
          WorkoutResultRecorder(blocks: blocks, startedAt: startedAt);

      // elapsed(200) < 前ブロック合計(300) → 負になるが 0 に
      final draft = recorder.buildDraft(
        status: 'abandoned',
        currentBlockIndex: 1,
        elapsedSeconds: 200,
        finishedAt: finishedAt,
      );

      expect(draft.blockResults[1].durationSeconds, 0);
    });
  });
}
