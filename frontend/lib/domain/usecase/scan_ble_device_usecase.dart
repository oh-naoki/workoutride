import '../../data/ble_connector.dart';
import '../model/device_scan_result.dart';

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
