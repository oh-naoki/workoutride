import 'dart:collection';

import 'package:workoutride/domain/usecase/get_power_meter_data_use_case.dart';

import '../model/power_meter_data.dart';

class GetCalculatedPowerMeterDataUseCase {
  final GetPowerMeterDataUseCase _getPowerMeterDataUseCase;

  GetCalculatedPowerMeterDataUseCase(
    this._getPowerMeterDataUseCase,
  );

  Stream<PowerMeterData> call() {
    final queue = Queue<PowerMeterData>(); // FIFOキュー（3秒分のデータを保持）
    const windowSize = 3; // 3秒

    return _getPowerMeterDataUseCase().map((value) {
      // 新しいデータをキューに追加
      queue.add(value);

      // キューのサイズが3秒を超えたら古いデータを削除
      if (queue.length > windowSize) {
        queue.removeFirst();
      }

      // powerとcadenceの合計を計算
      final totalPower = queue.fold(0, (sum, data) => sum + data.power);
      final totalCadence = queue.fold(0, (sum, data) => sum + data.cadence);

      // 平均値を計算（整数値として計算）
      final averagePower = totalPower ~/ queue.length;
      final averageCadence = totalCadence ~/ queue.length;

      // 3秒間の平均値を返す
      return PowerMeterData(
        power: averagePower,
        cadence: averageCadence,
      );
    });
  }
}
