import 'package:flutter/material.dart';
import 'package:workoutride/ui/home/home_screen.dart';
import 'package:workoutride/ui/workout/workout_screen.dart';
import 'package:workoutride/ui/workout_detail/workout_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workoutride/di/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
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
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/workout': (context) {
            final workoutId = ModalRoute.of(context)!.settings.arguments as int;
            return WorkoutScreen(workoutId: workoutId);
          },
          '/workout_detail': (context) {
            final workoutId = ModalRoute.of(context)!.settings.arguments as int;
            return WorkoutDetailScreen(workoutId: workoutId);
          },
        });
  }
}
