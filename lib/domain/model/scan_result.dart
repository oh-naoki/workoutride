import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_result.freezed.dart';

@freezed
class ScanResult with _$ScanResult {
  const factory ScanResult({
    required String deviceName,
    required String deviceAddress,
    required int rssi,
  }) = _ScanResult;
}
