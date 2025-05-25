import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workoutride/component/meter.dart';
import 'package:workoutride/ui/workout/workout_screen_state_notifier.dart';

class WorkoutScreen extends ConsumerWidget {
  final int workoutId;
  
  const WorkoutScreen({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(workoutScreenStateNotifierProvider(workoutId));

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // メーターを表示するエリア
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Meter(
                  power: uiState.power,
                  cadence: uiState.cadence,
                  maxPower: uiState.maxPower,
                  targetPower: uiState.targetPower,
                ),
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
                child: Builder(
                  builder: (context) {
                    if (uiState.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (uiState.errorMessage != null) {
                      return Center(
                        child: Text(
                          'エラーが発生しました: ${uiState.errorMessage}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (uiState.workoutBlocks.isEmpty) {
                      return const Center(
                        child: Text(
                          'ワークアウトブロックがありません',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: uiState.workoutBlocks.length,
                        itemBuilder: (context, index) {
                          final block = uiState.workoutBlocks[index];
                          return GestureDetector(
                            onTap: () {
                              // ブロックをタップした時の処理
                            },
                            child: _buildWorkoutCard(
                              name: block.blockType,
                              power: block.targetPower,
                              time: _formatDuration(block.duration),
                              isActive: index == 0,
                            ),
                          );
                        },
                      );
                    }
                  },
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
                  style: const TextStyle(
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
