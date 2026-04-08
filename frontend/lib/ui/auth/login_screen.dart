import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workoutride/di/providers.dart';
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
        if (kDebugMode) ...[
          const SizedBox(height: 24),
          _DebugPanel(),
        ],
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
    final stackTrace = ref.watch(authStateNotifierProvider).asError?.stackTrace;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'ログインエラー',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          SelectableText(
            error.toString(),
            style: const TextStyle(fontSize: 12, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          if (stackTrace != null) ...[
            const SizedBox(height: 8),
            SelectableText(
              stackTrace.toString(),
              style: const TextStyle(fontSize: 9, color: Colors.grey),
            ),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(authStateNotifierProvider.notifier).signInWithGoogle();
            },
            child: const Text('再試行'),
          ),
        ],
      ),
    );
  }
}

class _DebugPanel extends ConsumerStatefulWidget {
  @override
  ConsumerState<_DebugPanel> createState() => _DebugPanelState();
}

class _DebugPanelState extends ConsumerState<_DebugPanel> {
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(sharedPreferencesProvider);
    final saved = prefs.getString(debugApiUrlKey) ?? '';
    final ip = saved.replaceFirst('http://', '').replaceFirst(':3000/api/v1', '');
    _urlController = TextEditingController(text: ip);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _saveUrl() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final ip = _urlController.text.trim();
    if (ip.isEmpty) {
      await prefs.remove(debugApiUrlKey);
    } else {
      await prefs.setString(debugApiUrlKey, 'http://$ip:3000/api/v1');
    }
    ref.invalidate(dioProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('DEBUG', style: TextStyle(color: Colors.orange, fontSize: 12)),
          const SizedBox(height: 8),
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'Server IP',
              hintText: '192.168.x.x',
              prefixText: 'http://',
              suffixText: ':3000/api/v1',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _saveUrl,
                  child: const Text('URL を保存'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(authStateNotifierProvider.notifier).signInAsDebugUser();
                  },
                  child: const Text('Skip Login'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
