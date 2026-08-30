import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/domain/model/error/app_exception.dart';
import 'package:workoutride/app/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

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
            ref.read(authControllerProvider.notifier).signInWithGoogle();
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
    if (error.toString().toLowerCase().contains('cancel')) {
      return 'ログインがキャンセルされました。';
    }
    return AppException.messageFor(error);
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
            ref.read(authControllerProvider.notifier).signInWithGoogle();
          },
          child: const Text('再試行'),
        ),
      ],
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
    final ip =
        saved.replaceFirst('http://', '').replaceFirst(':3000/api/v1', '');
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
          const Text('DEBUG',
              style: TextStyle(color: Colors.orange, fontSize: 12)),
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
                    ref
                        .read(authControllerProvider.notifier)
                        .signInAsDebugUser();
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
