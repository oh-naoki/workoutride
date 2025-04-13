import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/ble_connector.dart';
import '../model/device_scan_result.dart';

part 'scan_ble_device_usecase.g.dart';

@riverpod
ScanBleDeviceUseCase scanBleDeviceUseCase(ScanBleDeviceUseCaseRef ref) {
  return ScanBleDeviceUseCase(ref.read(bleConnectorProvider));
}

class ScanBleDeviceUseCase {
  final BleConnector _bleConnector;

  ScanBleDeviceUseCase(this._bleConnector);

  Stream<List<DeviceScanResult>> call() {
    return _bleConnector.scan().map(
          (list) => list
              .where((r) => r.device.platformName.isNotEmpty)
              .map((r) => DeviceScanResult(
                    deviceName: r.device.platformName,
                    deviceAddress: r.device.remoteId.toString(),
                    rssi: r.rssi,
                  ))
              .toList(),
        );
  }
}
