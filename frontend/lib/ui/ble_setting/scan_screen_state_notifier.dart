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
    @Default(false) bool isConnecting,
    @Default(false) bool isConnected,
    String? errorMessage,
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
        state = state.copyWith(
          errorMessage: error.toString(),
        );
      },
      onDone: () {
        print('Scan completed');
      },
      cancelOnError: true,
    );
  }

  Future<void> onDeviceTap(DeviceScanResult result) async {
    if (state.isConnecting) return;

    try {
      state = state.copyWith(
        isConnecting: true,
        errorMessage: null,
      );

      // デバイスに接続
      await ref.read(connectBlePowerMeterUseCaseProvider)(result.deviceAddress);

      // 接続成功を設定
      state = state.copyWith(
        isConnected: true,
        isConnecting: false,
      );

      // 接続成功後にデータの購読を開始
      ref.read(getPowerMeterDataUseCaseProvider)().listen(
        (powerMeterData) {
          print('Power: ${powerMeterData.power}, Cadence: ${powerMeterData.cadence}');
        },
        onError: (error) {
          state = state.copyWith(
            errorMessage: error.toString(),
            isConnected: false,
          );
        },
        onDone: () {
          print('Power Meter Data completed');
        },
        cancelOnError: true,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        isConnecting: false,
        isConnected: false,
      );
    }
  }
}
