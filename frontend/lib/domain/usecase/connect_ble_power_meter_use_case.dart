import 'package:workoutride/data/ble_connector.dart';

class ConnectBlePowerMeterUseCase {
  final BleConnector _bleConnector;

  ConnectBlePowerMeterUseCase(
    this._bleConnector,
  );

  Future<void> call(String deviceId) async {
    await _bleConnector.connect(deviceId);
  }
}
