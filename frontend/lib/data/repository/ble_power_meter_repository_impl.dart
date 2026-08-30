import 'package:workoutride/data/ble_connector.dart';
import 'package:workoutride/domain/model/device_scan_result.dart';
import 'package:workoutride/domain/repository/ble_power_meter_repository.dart';

/// [BlePowerMeterRepository] の実装。`BleConnector`（Service）を包み、
/// flutter_blue_plus の `ScanResult` をドメインモデルへ変換する。
///
/// 変換をここに置くのは、外部ライブラリの型をドメインに漏らさないため
/// （docs/architecture.md §2.4）。以前は ScanBleDeviceUseCase が domain 側で
/// この変換をしていた。
class BlePowerMeterRepositoryImpl implements BlePowerMeterRepository {
  final BleConnector _bleConnector;

  BlePowerMeterRepositoryImpl(this._bleConnector);

  @override
  Future<void> initialize() => _bleConnector.initialize();

  @override
  Stream<List<DeviceScanResult>> scanDevices() {
    return _bleConnector.scan().map(
          (results) => results
              // 名前を持たないデバイスは選びようがないので除外する。
              .where((r) => r.device.platformName.isNotEmpty)
              .map((r) => DeviceScanResult(
                    deviceName: r.device.platformName,
                    deviceAddress: r.device.remoteId.toString(),
                    rssi: r.rssi,
                  ))
              .toList(),
        );
  }

  @override
  Future<void> connect(String deviceId) => _bleConnector.connect(deviceId);

  @override
  Future<bool> autoConnect() => _bleConnector.autoConnect();

  @override
  Future<String?> getSavedDeviceId() => _bleConnector.getSavedDeviceId();

  @override
  Future<void> disconnect() => _bleConnector.disconnect();
}
