import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workoutride/ui/ble_setting/scan_screen.dart';
import 'package:workoutride/ui/settings/weight_registration_dialog.dart';
import 'package:workoutride/ui/settings/ftp_registration_dialog.dart';
import 'package:workoutride/ui/settings/settings_screen_state_notifier.dart';
import 'package:workoutride/app/auth_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _showWeightRegistrationDialog(
      BuildContext context, WidgetRef ref, double? currentWeight) async {
    final result = await showDialog<double>(
      context: context,
      builder: (context) => WeightRegistrationDialog(
        currentWeight: currentWeight,
      ),
    );

    if (result != null) {
      await ref
          .read(settingsScreenStateNotifierProvider.notifier)
          .updateWeight(result);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('体重を${result.toStringAsFixed(1)}kgに設定しました'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _showFtpRegistrationDialog(
      BuildContext context, WidgetRef ref, int? currentFtp) async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) => FtpRegistrationDialog(currentFtp: currentFtp),
    );

    if (result != null) {
      await ref
          .read(settingsScreenStateNotifierProvider.notifier)
          .updateFtp(result);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('FTPを${result}Wに設定しました'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _navigateToBleSetting(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScanScreen()),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ログアウト'),
        content: const Text('本当にログアウトしますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('ログアウト'),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      await ref.read(authControllerProvider.notifier).signOut();
    }
  }

  Future<void> _showDeleteAccountDialog(
      BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const _DeleteAccountConfirmDialog(),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(authControllerProvider.notifier).deleteAccount();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('アカウントの削除に失敗しました。通信状況を確認して再度お試しください。'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(settingsScreenStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("設定", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: uiState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (uiState.errorMessage != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            uiState.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        IconButton(
                          onPressed: () => ref
                              .read(
                                  settingsScreenStateNotifierProvider.notifier)
                              .clearError(),
                          icon: const Icon(Icons.close, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildSectionTitle('ユーザー設定'),
                      _buildSettingTile(
                        title: '体重設定',
                        subtitle: uiState.currentWeight != null
                            ? '現在の体重: ${uiState.currentWeight!.toStringAsFixed(1)}kg'
                            : '体重が設定されていません',
                        icon: Icons.person,
                        onTap: () => _showWeightRegistrationDialog(
                            context, ref, uiState.currentWeight),
                      ),
                      const SizedBox(height: 16),
                      _buildSettingTile(
                        title: 'FTP設定',
                        subtitle: uiState.currentFtp != null
                            ? '現在のFTP: ${uiState.currentFtp}W'
                            : 'FTPが設定されていません',
                        icon: Icons.speed,
                        onTap: () => _showFtpRegistrationDialog(
                            context, ref, uiState.currentFtp),
                      ),
                      const SizedBox(height: 32),
                      _buildSectionTitle('デバイス設定'),
                      _buildSettingTile(
                        title: 'Bluetooth設定',
                        subtitle: 'パワーメーターの接続設定',
                        icon: Icons.bluetooth,
                        onTap: () => _navigateToBleSetting(context),
                      ),
                      const SizedBox(height: 32),
                      _buildSectionTitle('アカウント'),
                      _buildDangerSettingTile(
                        title: 'ログアウト',
                        subtitle: 'アカウントからログアウトします',
                        icon: Icons.logout,
                        onTap: () => _showLogoutDialog(context, ref),
                      ),
                      const SizedBox(height: 16),
                      _buildDangerSettingTile(
                        title: 'アカウント削除',
                        subtitle: 'アカウントとワークアウト履歴などの全データを完全に削除します',
                        icon: Icons.delete_forever,
                        onTap: () => _showDeleteAccountDialog(context, ref),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.grey[900],
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDangerSettingTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.grey[900],
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.red),
        onTap: onTap,
      ),
    );
  }
}

/// アカウント削除の確認ダイアログ。「削除」と入力しないと実行できない。
class _DeleteAccountConfirmDialog extends StatefulWidget {
  const _DeleteAccountConfirmDialog();

  @override
  State<_DeleteAccountConfirmDialog> createState() =>
      _DeleteAccountConfirmDialogState();
}

class _DeleteAccountConfirmDialogState
    extends State<_DeleteAccountConfirmDialog> {
  final _controller = TextEditingController();
  bool _canDelete = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('アカウント削除'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'アカウントを削除すると、ワークアウト履歴・FTP・体重などの全データが完全に削除されます。この操作は取り消せません。',
          ),
          const SizedBox(height: 16),
          const Text('続行するには「削除」と入力してください。'),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: '削除',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _canDelete = value.trim() == '削除';
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: _canDelete ? () => Navigator.of(context).pop(true) : null,
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('完全に削除する'),
        ),
      ],
    );
  }
}
