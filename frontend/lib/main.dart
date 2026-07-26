import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/ui/auth/auth_state_notifier.dart';
import 'package:workoutride/ui/auth/login_screen.dart';
import 'package:workoutride/ui/home/home_screen.dart';
import 'package:workoutride/ui/theme/app_colors.dart';
import 'package:workoutride/ui/workout/workout_screen.dart';
import 'package:workoutride/ui/workout_detail/workout_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.brand,
          primary: AppColors.brand,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.brand,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brand,
            foregroundColor: Colors.white,
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.brand,
        ),
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
