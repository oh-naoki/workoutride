import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/domain/usecase/connect_ble_power_meter_use_case.dart';
import 'package:workoutride/domain/usecase/get_power_meter_data_use_case.dart';
import 'package:workoutride/domain/usecase/scan_ble_device_usecase.dart';

import '../../domain/model/device_scan_result.dart';

part 'scan_screen_state_notifier.freezed.dart';
part 'scan_screen_state_notifier.g.dart';

@freezed
class ScanScreenUiState with _$ScanScreenUiState {
  const factory ScanScreenUiState({
    @Default([]) List<DeviceScanResult> scanResults,
  }) = _ScanScreenUiState;
}

@riverpod
class ScanScreenStateNotifier extends _$ScanScreenStateNotifier {
  @override
  ScanScreenUiState build() {
    return const ScanScreenUiState();
  }

  void scanDevice() {
    ref.read(scanBleDeviceUseCaseProvider)().listen(
      (results) {
        state = state.copyWith(
          scanResults: results,
        );
      },
      onError: (error) {
        print('Error: $error');
      },
      onDone: () {
        print('Scan completed');
      },
      cancelOnError: true,
    );
  }

  void onDeviceTap(DeviceScanResult result) {
    ref.read(connectBlePowerMeterUseCaseProvider)(result.deviceAddress);
    ref.read(getPowerMeterDataUseCaseProvider)().listen(
      (powerMeterData) {
        print('Power: ${powerMeterData.power}, Cadence: ${powerMeterData.cadence}');
      },
      onError: (error) {
        print('Error: $error');
      },
      onDone: () {
        print('Power Meter Data completed');
      },
      cancelOnError: true,
    );
  }
}
