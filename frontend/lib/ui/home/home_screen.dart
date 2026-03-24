import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workoutride/domain/model/workout/workout_summary.dart';
import 'package:workoutride/ui/history/history_screen.dart';
import 'package:workoutride/ui/settings/settings_screen.dart';
import 'package:workoutride/ui/home/home_screen_state_notifier.dart';
import 'package:workoutride/ui/workout_detail/workout_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(homeScreenStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? 'Home' : '履歴',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // ワークアウト一覧タブ
          SingleChildScrollView(
            child: Column(
              children: [
                BleConnectionStatus(uiState: uiState),
                const SectionTitle(title: "ワークアウト一覧"),
                Builder(
                  builder: (context) {
                    if (uiState.isLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (uiState.errorMessage != null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'エラーが発生しました: ${uiState.errorMessage}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    } else if (uiState.workoutSummaries.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.fitness_center, size: 64, color: Colors.grey[600]),
                              const SizedBox(height: 16),
                              const Text('ワークアウトがありません', style: TextStyle(color: Colors.grey, fontSize: 16)),
                              const SizedBox(height: 8),
                              const Text('トレーニングメニューを追加してください', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return WorkoutList(summaries: uiState.workoutSummaries);
                    }
                  },
                ),
              ],
            ),
          ),
          // 履歴タブ
          const HistoryScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1C1C1C),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'ワークアウト',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '履歴',
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class WorkoutList extends StatelessWidget {
  final List<WorkoutSummary> summaries;

  const WorkoutList({super.key, required this.summaries});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: summaries.length,
      itemBuilder: (context, index) {
        final summary = summaries[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: WorkoutItem(
            summary: summary,
          ),
        );
      },
    );
  }
}

class WorkoutItem extends StatelessWidget {
  final WorkoutSummary summary;

  const WorkoutItem({super.key, required this.summary});

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutDetailScreen(
              workoutId: summary.id,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            summary.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '合計時間: ${_formatDuration(summary.totalDuration)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'カテゴリ: ${summary.category}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BleConnectionStatus extends ConsumerWidget {
  final HomeScreenUiState uiState;

  const BleConnectionStatus({super.key, required this.uiState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: uiState.isBleConnected ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            uiState.isConnectingBle
              ? Icons.bluetooth_searching
              : uiState.isBleConnected
                ? Icons.bluetooth_connected
                : Icons.bluetooth_disabled,
            color: uiState.isConnectingBle
              ? Colors.blue
              : uiState.isBleConnected
                ? Colors.green
                : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  uiState.isConnectingBle
                    ? 'パワーメーターに接続中...'
                    : uiState.isBleConnected
                      ? 'パワーメーターに接続済み'
                      : 'パワーメーターが未接続',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (uiState.bleErrorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      uiState.bleErrorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (!uiState.isBleConnected && !uiState.isConnectingBle)
            TextButton(
              onPressed: () {
                ref.read(homeScreenStateNotifierProvider.notifier).retryBleConnection();
              },
              child: const Text(
                '再接続',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
