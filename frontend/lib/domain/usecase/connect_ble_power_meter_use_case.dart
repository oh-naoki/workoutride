import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/data/ble_connector.dart';

part 'connect_ble_power_meter_use_case.g.dart';

@riverpod
ConnectBlePowerMeterUseCase connectBlePowerMeterUseCase(ConnectBlePowerMeterUseCaseRef ref) {
  return ConnectBlePowerMeterUseCase(ref.read(bleConnectorProvider));
}

class ConnectBlePowerMeterUseCase {
  final BleConnector _bleConnector;

  ConnectBlePowerMeterUseCase(
    this._bleConnector,
  );

  Future<void> call(String deviceId) async {
    await _bleConnector.connect(deviceId);
  }
}
