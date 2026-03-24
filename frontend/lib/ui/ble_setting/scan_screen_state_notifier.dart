import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/di/providers.dart';

import '../../domain/model/device_scan_result.dart';

part 'scan_screen_state_notifier.freezed.dart';
part 'scan_screen_state_notifier.g.dart';

@freezed
class ScanScreenUiState with _$ScanScreenUiState {
  const factory ScanScreenUiState({
    @Default([]) List<DeviceScanResult> scanResults,
    @Default(false) bool isScanning,
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
    state = state.copyWith(isScanning: true);
    ref.read(scanBleDeviceUseCaseProvider)().listen(
      (results) {
        state = state.copyWith(
          scanResults: results,
        );
      },
      onError: (error) {
        state = state.copyWith(
          errorMessage: error.toString(),
          isScanning: false,
        );
      },
      onDone: () {
        state = state.copyWith(isScanning: false);
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

      await ref.read(connectBlePowerMeterUseCaseProvider)(result.deviceAddress);

      state = state.copyWith(
        isConnected: true,
        isConnecting: false,
      );

      ref.read(getPowerMeterDataUseCaseProvider)().listen(
        (powerMeterData) {
          // Power data received
        },
        onError: (error) {
          state = state.copyWith(
            errorMessage: error.toString(),
            isConnected: false,
          );
        },
        onDone: () {
          // Power Meter Data completed
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
