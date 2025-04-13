import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/data/ble_connector.dart';
import 'package:workoutride/domain/model/power_meter_data.dart';
import 'package:flutter/foundation.dart';

part 'get_power_meter_data_use_case.g.dart';

@riverpod
GetPowerMeterDataUseCase getPowerMeterDataUseCase(GetPowerMeterDataUseCaseRef ref) {
  return GetPowerMeterDataUseCase(ref.read(bleConnectorProvider));
}

class GetPowerMeterDataUseCase {
  final BleConnector bleConnector;

  int lastCrankRevolutions = 0;
  int lastCrankEventTime = 0;

  GetPowerMeterDataUseCase(
    this.bleConnector,
  );

  Stream<PowerMeterData> call() {
    return bleConnector.notify("2A63").map((value) {
      return processData(value);
    });
  }

  PowerMeterData processData(List<int> value) {
    if (value.isEmpty || value.length <= 2) {
      return const PowerMeterData(power: 0, cadence: 0);
    }
  
    // Flags の最初の 2 バイトを取得
    int flags = (value[1] << 8) | value[0];
    int index = 2; // データ読み取りの開始位置（フラグの後）

    // フラグを16進数に変換して表示
    print("Flags: 0x${flags.toRadixString(16).padLeft(4, '0')}");

    // Instantaneous Power (必須フィールド, 2 バイト)
    int instantaneousPower = (value[index + 1] << 8) | value[index];
    print("Instantaneous Power: $instantaneousPower W");
    index += 2;

    // Pedal Power Balance (任意, Flag の Bit 0 が立っている場合)
    if ((flags & 0x001) != 0) {
      index += 1;
    }

    // Crank Revolution Data (任意, Flag の Bit 5 が立っている場合)
    double crankRpm = 0;
    if ((flags & 0x020) != 0) {
      int cumulativeCrankRevolutions = (value[index + 1] << 8) | value[index];
      index += 2;
      int currentCrankEventTime = (value[index + 1] << 8) | value[index];
      int timeDiff = currentCrankEventTime - lastCrankEventTime;
      int revDiff = cumulativeCrankRevolutions - lastCrankRevolutions;
      if (timeDiff != 0 && revDiff != 0) {
        crankRpm = (revDiff * 60 / (timeDiff / 1024));
      }
      lastCrankEventTime = currentCrankEventTime;
      lastCrankRevolutions = cumulativeCrankRevolutions;
      index += 2;
    }
    return PowerMeterData(power: instantaneousPower, cadence: crankRpm.toInt());
  }
}
