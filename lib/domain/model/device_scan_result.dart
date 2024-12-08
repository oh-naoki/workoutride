import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_scan_result.freezed.dart';

@freezed
class DeviceScanResult with _$DeviceScanResult {
  const factory DeviceScanResult({
    required String deviceName,
    required String deviceAddress,
    required int rssi,
  }) = _DeviceScanResult;
}
