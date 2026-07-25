import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/ui/workout_detail/workout_detail_screen_state_notifier.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/ui/workout/workout_screen.dart';
import 'package:workoutride/ui/theme/app_colors.dart';

class WorkoutDetailScreen extends ConsumerWidget {
  final int workoutId;
  
  const WorkoutDetailScreen({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(workoutDetailScreenStateNotifierProvider(workoutId));
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'ワークアウト詳細',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: WorkoutDetailBody(uiState: uiState, workoutId: workoutId),
      ),
    );
  }
}

class WorkoutDetailBody extends StatelessWidget {
  final WorkoutDetailScreenUiState uiState;
  final int workoutId;
  
  const WorkoutDetailBody({super.key, required this.uiState, required this.workoutId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          uiState.workoutSummary?.name ?? 'No name available',
          style: const TextStyle(color: Colors.white, fontSize: 20),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            "ワークアウト内容",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        Builder(
          builder: (context) {
            if (uiState.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (uiState.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'エラーが発生しました: ${uiState.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            } else if (uiState.workoutBlocks.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.playlist_remove, size: 64, color: Colors.grey[600]),
                      const SizedBox(height: 16),
                      const Text('ワークアウトブロックがありません', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      const SizedBox(height: 8),
                      const Text('別のワークアウトを選択してください', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              );
            } else {
              return Column(
                children: [
                  WorkoutMenu(blocks: uiState.workoutBlocks, workoutId: workoutId),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkoutScreen(workoutId: workoutId),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brand,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'ワークアウト開始',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ],
      ),
    );
  }
}

class WorkoutMenu extends ConsumerWidget {
  final List<WorkoutBlock> blocks;
  final int workoutId;
  
  const WorkoutMenu({super.key, required this.blocks, required this.workoutId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FTPを取得（デフォルト値200W）
    
    return FutureBuilder<int?>(
      future: ref.read(getUserFtpUseCaseProvider).call(),
      builder: (context, snapshot) {
        final ftpOrNull = snapshot.data;
        // FTP取得が完了する前（ロード中）はアラートを出さない。
        // 取得完了かつ未設定(null)のときだけデフォルト扱いとしてアラートを表示する。
        final isResolved = snapshot.connectionState == ConnectionState.done;
        final ftpIsDefault = isResolved && ftpOrNull == null;
        final ftp = ftpOrNull ?? 200; // デフォルト200W

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ftpIsDefault)
              Container(
                color: Colors.orange[100],
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'FTPが未設定のためデフォルト値(200W)を使用しています。設定から変更できます。',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ListView.separated(
              itemCount: blocks.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final block = blocks[index];
                final targetWatts = block.calculateTargetPower(ftp);
                return WorkoutMenuItem(
                  type: block.blockType,
                  power: targetWatts,
                  duration: block.durationSeconds,
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8);
              },
            ),
          ],
        );
      },
    );
  }
}

class WorkoutMenuItem extends StatelessWidget {
  final String type;
  final int power;
  final int duration;
  
  const WorkoutMenuItem({
    super.key,
    required this.type,
    required this.power,
    required this.duration,
  });
  
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontFeatures: [FontFeature.tabularFigures()],
    );

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF4C4C4C),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // タイトルは可変幅。長い場合は省略して右列の位置を固定に保つ
            Expanded(
              child: Text(
                type,
                style: textStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // W・時間は固定幅＋右寄せで、行ごとに桁が変わっても縦位置を揃える
            SizedBox(
              width: 72,
              child: Text(
                "$power W",
                style: textStyle,
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(
              width: 64,
              child: Text(
                _formatDuration(duration),
                style: textStyle,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
