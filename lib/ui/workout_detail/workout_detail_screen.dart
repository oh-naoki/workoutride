import 'package:flutter/material.dart';

class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              WorkoutDetailHeader(),
              WorkoutDetailBody(),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkoutDetailHeader extends StatelessWidget {
  const WorkoutDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {},
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
  const WorkoutDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
          style: TextStyle(color: Colors.white, fontSize: 20),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            "ワークアウト内容",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        WorkoutMenu(),
      ],
    );
  }
}

class WorkoutMenu extends StatelessWidget {
  const WorkoutMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return WorkoutMenuItem();
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
    );
  }
}

class WorkoutMenuItem extends StatelessWidget {
  const WorkoutMenuItem({super.key});

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
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Hold", style: textStyle),
            Text("300[W]", style: textStyle),
            Text("00:10", style: textStyle),
          ],
        ),
      ),
    );
  }
}
