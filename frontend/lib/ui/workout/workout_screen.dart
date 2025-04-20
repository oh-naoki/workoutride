import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workoutride/component/meter.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/workout/workout_summary.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_summaries_use_case.dart';
import 'package:workoutride/ui/workout_detail/workout_detail_screen.dart';

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutSummariesState = ref.watch(workoutSummariesProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // メーターを表示するエリア
            const Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Meter(),
              ),
            ),
            
            // 3つのボタンを表示するエリア
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(),
                  _buildControlButton(),
                  _buildControlButton(),
                ],
              ),
            ),
            
            // スクロール可能なカードリストを表示するエリア
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: workoutSummariesState.when(
                  data: (summaries) {
                    if (summaries.isEmpty) {
                      return const Center(
                        child: Text(
                          'ワークアウトがありません',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: summaries.length,
                      itemBuilder: (context, index) {
                        final summary = summaries[index];
                        return GestureDetector(
                          onTap: () {
                            if (summary.workouts.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkoutDetailScreen(
                                    workoutId: summary.workouts[0].id,
                                  ),
                                ),
                              );
                            }
                          },
                          child: _buildWorkoutCard(
                            name: summary.name,
                            power: summary.totalDuration,
                            time: _formatDuration(summary.totalDuration),
                            isActive: index == 0,
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stackTrace) => Center(
                    child: Text(
                      'エラーが発生しました: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // コントロールボタンを作成するメソッド
  Widget _buildControlButton() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // 秒数をMM:SS形式に変換
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // ワークアウトカードを作成するメソッド
  Widget _buildWorkoutCard({
    required String name,
    required int power,
    required String time,
    required bool isActive,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      color: const Color(0xFF333333),
      child: Column(
        children: [
          // パワー表示部分
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF333333),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$power',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'w',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // 時間表示部分
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 40,
              child: Stack(
                children: [
                  LinearProgressIndicator(
                    value: 0.5, // 進捗率（0.0 ~ 1.0）
                    minHeight: 40,
                    backgroundColor: Colors.grey[800], // 未進捗部分の色
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isActive ? const Color(0xFF51DB40) : const Color(0xFF333333),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Text(
                        time,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
