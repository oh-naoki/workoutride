import 'package:workoutride/data/ble_connector.dart';

class AutoConnectBlePowerMeterUseCase {
  final BleConnector _bleConnector;

  AutoConnectBlePowerMeterUseCase(this._bleConnector);

  /// 保存されたデバイスに自動接続を試行
  Future<bool> call() async {
    return await _bleConnector.autoConnect();
  }

  /// 保存されたデバイスIDを取得
  Future<String?> getSavedDeviceId() async {
    return await _bleConnector.getSavedDeviceId();
  }
}
