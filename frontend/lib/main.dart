import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/ui/auth/auth_state_notifier.dart';
import 'package:workoutride/ui/auth/login_screen.dart';
import 'package:workoutride/ui/home/home_screen.dart';
import 'package:workoutride/ui/workout/workout_screen.dart';
import 'package:workoutride/ui/workout_detail/workout_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);

    return MaterialApp(
      title: 'WorkoutRide',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: authState.when(
        data: (state) => state.when(
          authenticated: (user) => const HomeScreen(),
          unauthenticated: () => const LoginScreen(),
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        ),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const LoginScreen(),
      ),
      routes: {
        '/workout': (context) {
          final workoutId = ModalRoute.of(context)!.settings.arguments as int;
          return WorkoutScreen(workoutId: workoutId);
        },
        '/workout_detail': (context) {
          final workoutId = ModalRoute.of(context)!.settings.arguments as int;
          return WorkoutDetailScreen(workoutId: workoutId);
        },
      },
    );
  }
}
