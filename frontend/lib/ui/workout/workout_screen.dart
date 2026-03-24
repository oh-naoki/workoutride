import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workoutride/component/meter.dart';
import 'package:workoutride/ui/workout/developer_menu.dart';
import 'package:workoutride/ui/workout/workout_screen_state_notifier.dart';

class WorkoutScreen extends ConsumerStatefulWidget {
  final int workoutId;
  
  const WorkoutScreen({super.key, required this.workoutId});

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showDeveloperMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const DeveloperMenu(),
    );
  }

  // 現在のブロックまでスクロール
  void _scrollToCurrentBlock(int currentBlockIndex) {
    if (!_scrollController.hasClients) return;

    final itemHeight = 140.0; // カードの高さ + マージン
    final targetOffset = currentBlockIndex * itemHeight;

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(workoutScreenStateNotifierProvider(widget.workoutId));

    // 現在のブロックが変更されたら自動スクロール
    ref.listen(workoutScreenStateNotifierProvider(widget.workoutId), (previous, next) {
      if (previous?.currentBlockIndex != next.currentBlockIndex) {
        _scrollToCurrentBlock(next.currentBlockIndex);
      }
    });

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            if (kDebugMode)
              IconButton(
                icon: const Icon(Icons.bug_report, color: Colors.white),
                onPressed: () => _showDeveloperMenu(context),
              ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // メーターを表示するエリア
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: Meter(
                              power: uiState.power,
                              cadence: uiState.cadence,
                              maxPower: uiState.maxPower,
                              targetPower: uiState.targetPower,
                            ),
                          ),
                          // パワーアラートメッセージ表示エリア
                          if (uiState.powerAlertMessage != null)
                            Container(
                              margin: const EdgeInsets.only(top: 8.0),
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: uiState.powerAlertMessage!.color.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                uiState.powerAlertMessage!.message,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      // カウントダウン表示（Meterの上に重ねる）
                      if (uiState.isCountingDown)
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(32.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${uiState.countdownSeconds}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 72,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'ワークアウト開始まで',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
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
                    _buildPauseResumeButton(uiState.isPaused),
                    _buildStopButton(),
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
                          controller: _scrollController,
                          itemCount: uiState.workoutBlocks.length,
                          itemBuilder: (context, index) {
                            final block = uiState.workoutBlocks[index];
                            final isCurrentBlock = index == uiState.currentBlockIndex;
                            
                            // 現在のブロックの経過時間を計算
                            int blockElapsedSeconds = 0;
                            if (isCurrentBlock) {
                              int previousBlocksTime = 0;
                              for (var i = 0; i < index; i++) {
                                previousBlocksTime += uiState.workoutBlocks[i].durationSeconds;
                              }
                              blockElapsedSeconds = uiState.elapsedSeconds - previousBlocksTime;
                            }
      
                            return GestureDetector(
                              onTap: () {
                                // ブロックをタップした時の処理
                              },
                              child: _buildWorkoutCard(
                                name: block.blockType,
                                power: block.calculateTargetPower(uiState.userFtp),
                                time: _formatDuration(block.durationSeconds),
                                isActive: isCurrentBlock,
                                progress: isCurrentBlock 
                                  ? blockElapsedSeconds / block.durationSeconds
                                  : index < uiState.currentBlockIndex ? 1.0 : 0.0,
                                elapsedTime: isCurrentBlock 
                                  ? _formatDuration(blockElapsedSeconds)
                                  : null,
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

  // 一時停止・再開ボタンを作成するメソッド
  Widget _buildPauseResumeButton(bool isPaused) {
    return GestureDetector(
      onTap: () {
        ref.read(workoutScreenStateNotifierProvider(widget.workoutId).notifier).togglePauseResume();
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isPaused ? Colors.green : Colors.orange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isPaused ? Icons.play_arrow : Icons.pause,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  // ワークアウト終了ボタンを作成するメソッド
  Widget _buildStopButton() {
    return GestureDetector(
      onTap: () {
        _showStopWorkoutDialog();
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.stop,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  // ワークアウト終了確認ダイアログを表示するメソッド
  void _showStopWorkoutDialog() {
    // まず一時停止する
    final notifier = ref.read(workoutScreenStateNotifierProvider(widget.workoutId).notifier);
    final uiState = ref.read(workoutScreenStateNotifierProvider(widget.workoutId));
    final wasPaused = uiState.isPaused;
    
    if (!wasPaused) {
      notifier.togglePauseResume();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ワークアウト終了'),
          content: const Text('ワークアウトを終了しますか？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // キャンセル時は再開する（元々一時停止していなかった場合のみ）
                if (!wasPaused) {
                  notifier.togglePauseResume();
                }
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // ワークアウト結果を保存してから前画面に戻る
                await notifier.stopWorkout();
                if (mounted) {
                  Navigator.of(this.context).pop();
                }
              },
              child: const Text('終了'),
            ),
          ],
        );
      },
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
    required double progress,
    String? elapsedTime,
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
                    value: progress,
                    minHeight: 40,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isActive ? const Color(0xFF51DB40) : const Color(0xFF333333),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Text(
                        elapsedTime != null ? '$elapsedTime / $time' : time,
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
