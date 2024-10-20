import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/model/scan_result.dart';

part 'scan_screen_state_notifier.freezed.dart';
part 'scan_screen_state_notifier.g.dart';

@freezed
class ScanScreenUiState with _$ScanScreenUiState {
  const factory ScanScreenUiState({
    @Default([]) List<ScanResult> scanResults,
  }) = _ScanScreenUiState;
}

@riverpod
class ScanScreenStateNotifier extends _$ScanScreenStateNotifier {
  @override
  ScanScreenUiState build() {
    return const ScanScreenUiState();
  }

  void scanDevice() {
    // TODO: BLE Device Scanning
    state = state.copyWith(
      scanResults: [
        ScanResult(
          deviceName: 'Device 1',
          deviceAddress: '00:00:00:00:00:00',
          rssi: -50,
        ),
        ScanResult(
          deviceName: 'Device 2',
          deviceAddress: '00:00:00:00:00:01',
          rssi: -60,
        ),
        ScanResult(
          deviceName: 'Device 3',
          deviceAddress: '00:00:00:00:00:02',
          rssi: -70,
        ),
      ],
    );
  }
}
