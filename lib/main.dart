import 'package:flutter/material.dart';
import 'package:workoutride/ui/ble_setting/scan_screen.dart';
import 'package:workoutride/ui/workout/workout_screen.dart';
import 'package:workoutride/ui/workout_detail/workout_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const WorkoutScreen());
  }
}
