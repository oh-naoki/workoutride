import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workoutride/domain/model/workout/workout_result.dart';
import 'package:workoutride/ui/history/history_screen_view_model.dart';
import 'package:workoutride/ui/history/workout_result_detail_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(historyScreenViewModelProvider);

    if (uiState.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (uiState.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'エラーが発生しました: ${uiState.errorMessage}',
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  ref
                      .read(historyScreenViewModelProvider.notifier)
                      .refreshWorkoutResults();
                },
                child: const Text('再読み込み'),
              ),
            ],
          ),
        ),
      );
    }

    if (uiState.workoutResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 64, color: Colors.grey[600]),
              const SizedBox(height: 16),
              const Text('まだ履歴がありません',
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 8),
              const Text('ワークアウトを完了すると履歴が表示されます',
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref
            .read(historyScreenViewModelProvider.notifier)
            .refreshWorkoutResults();
      },
      child: ListView.builder(
        itemCount: uiState.workoutResults.length,
        itemBuilder: (context, index) {
          final result = uiState.workoutResults[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: WorkoutResultItem(result: result),
          );
        },
      ),
    );
  }
}

class WorkoutResultItem extends StatelessWidget {
  final WorkoutResult result;

  const WorkoutResultItem({super.key, required this.result});

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    if (hours > 0) {
      return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
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

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutResultDetailScreen(result: result),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(8),
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
                    fontSize: 12,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isCompleted ? '完了' : '中断',
                    style: TextStyle(
                      color: isCompleted ? Colors.green : Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _StatItem(
                  label: '時間',
                  value: _formatDuration(result.totalDurationSeconds),
                ),
                const SizedBox(width: 24),
                if (result.averagePower != null)
                  _StatItem(
                    label: '平均パワー',
                    value: '${result.averagePower}w',
                  ),
                if (result.averagePower != null) const SizedBox(width: 24),
                if (result.maxPower != null)
                  _StatItem(
                    label: '最大パワー',
                    value: '${result.maxPower}w',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
