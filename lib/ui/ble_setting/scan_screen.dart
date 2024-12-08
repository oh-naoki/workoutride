import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:workoutride/ui/ble_setting/scan_screen_state_notifier.dart';

class ScanScreen extends HookConsumerWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(scanScreenStateNotifierProvider.notifier).scanDevice();
      return null;
    }, []);

    final scanResults = ref.watch(scanScreenStateNotifierProvider).scanResults;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Devices", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            for (final result in scanResults)
              ListTile(
                title: result.deviceName,
                onTap: () {
                  ref.read(scanScreenStateNotifierProvider.notifier).onDeviceTap(result);
                },
              ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 16)),
          ],
        ),
      ),
    );
  }
}

class ListTile extends StatelessWidget {
  const ListTile({
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
