import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:workoutride/domain/model/device_scan_result.dart';
import 'package:workoutride/ui/ble_setting/scan_screen_state_notifier.dart';

class ScanScreen extends HookConsumerWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(scanScreenStateNotifierProvider.notifier).startScan();
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
        title:
            const Text("Find Devices", style: TextStyle(color: Colors.white)),
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
          Column(
            children: [
              if (uiState.isScanning)
                const LinearProgressIndicator(
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation(Colors.orange),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (uiState.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Text(
                              uiState.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      Text(
                        uiState.isScanning
                            ? 'パワーメーターを検索しています…'
                            : '${uiState.scanResults.length}件見つかりました',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final result in uiState.scanResults)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: DeviceListTile(
                            result: result,
                            onTap: () {
                              ref
                                  .read(
                                      scanScreenStateNotifierProvider.notifier)
                                  .onDeviceTap(result);
                            },
                          ),
                        ),
                      if (uiState.scanResults.isEmpty && !uiState.isScanning)
                        const Padding(
                          padding: EdgeInsets.only(top: 48),
                          child: Column(
                            children: [
                              Icon(Icons.bluetooth_searching,
                                  size: 48, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'パワーメーターが見つかりません',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Bluetoothをオンにして、デバイスを近くに置いてください',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (uiState.isConnecting)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.orange),
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
    required this.result,
    required this.onTap,
  });

  final DeviceScanResult result;
  final VoidCallback onTap;

  IconData get _signalIcon {
    if (result.rssi >= -60) return Icons.signal_cellular_alt;
    if (result.rssi >= -80) return Icons.signal_cellular_alt_2_bar;
    return Icons.signal_cellular_alt_1_bar;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: const Icon(Icons.bolt, color: Colors.orange),
        title: Text(
          result.deviceName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          result.deviceAddress,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
        trailing: Icon(_signalIcon, color: Colors.grey[400], size: 20),
        onTap: onTap,
      ),
    );
  }
}
