import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/ui/ble_setting/scan_screen.dart';
import 'package:workoutride/ui/settings/weight_registration_dialog.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  double? _currentWeight;

  @override
  void initState() {
    super.initState();
    _loadCurrentWeight();
  }

  Future<void> _loadCurrentWeight() async {
    try {
      final useCase = ref.read(getUserProfileUseCaseProvider);
      final profile = await useCase();
      if (mounted) {
        setState(() {
          _currentWeight = profile?.weight;
        });
      }
    } catch (e) {
      // エラーハンドリング（ログなど）
    }
  }

  Future<void> _showWeightRegistrationDialog() async {
    final result = await showDialog<double>(
      context: context,
      builder: (context) => WeightRegistrationDialog(
        currentWeight: _currentWeight,
      ),
    );

    if (result != null) {
      setState(() {
        _currentWeight = result;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('体重を${result.toStringAsFixed(1)}kgに設定しました'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _navigateToBleSetting() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScanScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('ユーザー設定'),
          _buildSettingTile(
            title: '体重設定',
            subtitle: _currentWeight != null 
                ? '現在の体重: ${_currentWeight!.toStringAsFixed(1)}kg'
                : '体重が設定されていません',
            icon: Icons.person,
            onTap: _showWeightRegistrationDialog,
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('デバイス設定'),
          _buildSettingTile(
            title: 'Bluetooth設定',
            subtitle: 'パワーメーターの接続設定',
            icon: Icons.bluetooth,
            onTap: _navigateToBleSetting,
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