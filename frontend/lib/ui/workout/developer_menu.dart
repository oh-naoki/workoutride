import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:workoutride/domain/model/mock_pattern.dart';
import 'package:workoutride/di/providers.dart';

class DeveloperMenu extends ConsumerWidget {
  const DeveloperMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMock = ref.watch(mockModeProvider);
    final currentPattern = ref.watch(mockPatternSelectionProvider);

    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '開発者メニュー',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // モック切り替えスイッチ
              SwitchListTile(
                title: const Text(
                  'モックモード',
                  style: TextStyle(color: Colors.white),
                ),
                value: isMock,
                onChanged: (_) => ref.read(mockModeProvider.notifier).toggle(),
              ),
              // パターン選択（モックモード時のみ表示）
              if (isMock) ...[
                const SizedBox(height: 16),
                const Text(
                  'パターン選択',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButton<MockPattern>(
                  value: currentPattern,
                  dropdownColor: Colors.grey[800],
                  items: MockPattern.values.map((pattern) {
                    return DropdownMenuItem(
                      value: pattern,
                      child: Text(
                        pattern.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (pattern) {
                    if (pattern != null) {
                      ref
                          .read(mockPatternSelectionProvider.notifier)
                          .setPattern(pattern);
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
