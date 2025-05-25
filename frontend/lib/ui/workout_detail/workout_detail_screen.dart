import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/ui/workout/workout_screen.dart';
import 'package:workoutride/ui/workout_detail/workout_detail_screen_state_notifier.dart';

class WorkoutDetailScreen extends ConsumerWidget {
  final int workoutId;
  
  const WorkoutDetailScreen({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(workoutDetailScreenStateNotifierProvider(workoutId));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              WorkoutDetailHeader(workoutId: workoutId),
              WorkoutDetailBody(uiState: uiState),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkoutDetailHeader extends ConsumerWidget {
  final int workoutId;
  
  const WorkoutDetailHeader({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Text(
            "Workout Title",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutScreen(workoutId: workoutId),
                ),
              );
            },
            icon: const Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class WorkoutDetailBody extends StatelessWidget {
  final WorkoutDetailScreenUiState uiState;
  
  const WorkoutDetailBody({super.key, required this.uiState});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
          style: TextStyle(color: Colors.white, fontSize: 20),
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
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    'エラーが発生しました: ${uiState.errorMessage}',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            } else if (uiState.workoutBlocks.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    'ワークアウトブロックがありません',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            } else {
              return WorkoutMenu(blocks: uiState.workoutBlocks);
            }
          },
        ),
      ],
    );
  }
}

class WorkoutMenu extends StatelessWidget {
  final List<WorkoutBlock> blocks;
  
  const WorkoutMenu({super.key, required this.blocks});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: blocks.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final block = blocks[index];
        return WorkoutMenuItem(
          type: block.blockType,
          power: block.targetPower,
          duration: block.duration,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
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
    );

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF4C4C4C),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(type, style: textStyle),
            Text("$power[W]", style: textStyle),
            Text(_formatDuration(duration), style: textStyle),
          ],
        ),
      ),
    );
  }
}
