import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workoutride/ui/ble_setting/scan_screen.dart';
import 'package:workoutride/ui/settings/weight_registration_dialog.dart';
import 'package:workoutride/ui/settings/ftp_registration_dialog.dart';
import 'package:workoutride/ui/settings/settings_screen_state_notifier.dart';
import 'package:workoutride/di/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _showWeightRegistrationDialog(BuildContext context, WidgetRef ref, double? currentWeight) async {
    final result = await showDialog<double>(
      context: context,
      builder: (context) => WeightRegistrationDialog(
        currentWeight: currentWeight,
      ),
    );

    if (result != null) {
      await ref.read(settingsScreenStateNotifierProvider.notifier).updateWeight(result);
      
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

  Future<void> _showFtpRegistrationDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const FtpRegistrationDialog(),
    );

    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('FTPを設定しました'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _navigateToBleSetting(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScanScreen()),
    );
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
                      color: Colors.red.withOpacity(0.1),
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
                          onPressed: () => ref.read(settingsScreenStateNotifierProvider.notifier).clearError(),
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
                        onTap: () => _showWeightRegistrationDialog(context, ref, uiState.currentWeight),
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<int?>(
                        future: ref.read(getUserFtpUseCaseProvider).call(),
                        builder: (context, snapshot) {
                          final currentFtp = snapshot.data;
                          return _buildSettingTile(
                            title: 'FTP設定',
                            subtitle: currentFtp != null 
                                ? '現在のFTP: ${currentFtp}W'
                                : 'FTPが設定されていません',
                            icon: Icons.speed,
                            onTap: () => _showFtpRegistrationDialog(context, ref),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      _buildSectionTitle('デバイス設定'),
                      _buildSettingTile(
                        title: 'Bluetooth設定',
                        subtitle: 'パワーメーターの接続設定',
                        icon: Icons.bluetooth,
                        onTap: () => _navigateToBleSetting(context),
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
}