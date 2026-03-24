import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:workoutride/di/providers.dart';
import 'package:workoutride/ui/ble_setting/scan_screen_state_notifier.dart';

class ScanScreen extends HookConsumerWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(bleConnectorProvider).initialize().then((_) {
        ref.read(scanScreenStateNotifierProvider.notifier).scanDevice();
      }).catchError((e) {
        ref.read(scanScreenStateNotifierProvider.notifier).setError(
          'Bluetoothの初期化に失敗しました: $e',
        );
      });
      return null;
    }, []);

    final uiState = ref.watch(scanScreenStateNotifierProvider);

    useEffect(() {
      if (uiState.isConnected) {
        Navigator.of(context).pop();
      }
      return null;
    }, [uiState.isConnected]);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Devices", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (uiState.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      uiState.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                for (final result in uiState.scanResults)
                  DeviceListTile(
                    title: result.deviceName,
                    onTap: () {
                      ref.read(scanScreenStateNotifierProvider.notifier).onDeviceTap(result);
                    },
                  ),
                if (uiState.scanResults.isEmpty && !uiState.isScanning)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.bluetooth_searching, size: 48, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'デバイスが見つかりません',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Bluetoothをオンにして、デバイスを近くに置いてください',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 16)),
              ],
            ),
          ),
          if (uiState.isConnecting)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

class DeviceListTile extends StatelessWidget {
  const DeviceListTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
