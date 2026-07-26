import 'package:flutter/material.dart';
import 'package:workoutride/domain/model/workout/workout_result.dart';

class WorkoutResultDetailScreen extends StatelessWidget {
  final WorkoutResult result;

  const WorkoutResultDetailScreen({super.key, required this.result});

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    if (hours > 0) {
      return '${hours}h ${minutes.toString().padLeft(2, '0')}m ${secs.toString().padLeft(2, '0')}s';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.year}/${local.month.toString().padLeft(2, '0')}/${local.day.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = result.status == 'completed';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('ワークアウト結果', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // サマリーカード
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCompleted
                      ? Colors.green.withValues(alpha: 0.5)
                      : Colors.orange.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDate(result.startedAt),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.orange.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isCompleted ? '完了' : '中断',
                          style: TextStyle(
                            color: isCompleted ? Colors.green : Colors.orange,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _SummaryStatCard(
                        label: '合計時間',
                        value: _formatDuration(result.totalDurationSeconds),
                      ),
                      if (result.averagePower != null)
                        _SummaryStatCard(
                          label: '平均パワー',
                          value: '${result.averagePower}w',
                        ),
                      if (result.maxPower != null)
                        _SummaryStatCard(
                          label: '最大パワー',
                          value: '${result.maxPower}w',
                        ),
                      if (result.averageCadence != null)
                        _SummaryStatCard(
                          label: '平均ケイデンス',
                          value: '${result.averageCadence}rpm',
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // ブロック結果
            if (result.workoutBlockResults.isNotEmpty) ...[
              const Text(
                'ブロック別結果',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...result.workoutBlockResults.map((blockResult) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatDuration(blockResult.durationSeconds),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (blockResult.averagePower != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            children: [
                              const Text(
                                '平均',
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 10),
                              ),
                              Text(
                                '${blockResult.averagePower}w',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (blockResult.maxPower != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            children: [
                              const Text(
                                '最大',
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 10),
                              ),
                              Text(
                                '${blockResult.maxPower}w',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (blockResult.averageCadence != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            children: [
                              const Text(
                                'rpm',
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 10),
                              ),
                              Text(
                                '${blockResult.averageCadence}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class _SummaryStatCard extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryStatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
