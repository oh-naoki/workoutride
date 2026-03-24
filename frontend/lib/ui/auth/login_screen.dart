import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workoutride/ui/auth/auth_state_notifier.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);

    return Scaffold(
      body: Center(
        child: authState.when(
          data: (state) => state.maybeWhen(
            loading: () => const CircularProgressIndicator(),
            orElse: () => _buildLoginContent(context, ref),
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, _) => _buildErrorContent(context, ref, error),
        ),
      ),
    );
  }

  Widget _buildLoginContent(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'WorkoutRide',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 48),
        ElevatedButton.icon(
          onPressed: () {
            ref.read(authStateNotifierProvider.notifier).signInWithGoogle();
          },
          icon: const Icon(Icons.login),
          label: const Text('Sign in with Google'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  String _friendlyErrorMessage(dynamic error) {
    final msg = error.toString().toLowerCase();
    if (msg.contains('network') || msg.contains('socket') || msg.contains('connection')) {
      return 'ネットワークエラーが発生しました。通信状況を確認してください。';
    }
    if (msg.contains('cancel') || msg.contains('cancelled')) {
      return 'ログインがキャンセルされました。';
    }
    return 'ログインに失敗しました。しばらくしてから再試行してください。';
  }

  Widget _buildErrorContent(BuildContext context, WidgetRef ref, Object error) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 48, color: Colors.red),
        const SizedBox(height: 16),
        Text(
          'ログインエラー',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(_friendlyErrorMessage(error)),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            ref.read(authStateNotifierProvider.notifier).signInWithGoogle();
          },
          child: const Text('再試行'),
        ),
      ],
    );
  }
}
