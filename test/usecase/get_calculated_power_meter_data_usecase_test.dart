import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:workoutride/domain/model/power_meter_data.dart';
import 'package:workoutride/domain/usecase/get_calculated_power_meter_data_usecase.dart';
import 'package:workoutride/domain/usecase/get_power_meter_data_use_case.dart';

import 'get_calculated_power_meter_data_usecase_test.mocks.dart';

// モックを生成
@GenerateMocks([GetPowerMeterDataUseCase])
void main() {
  setUp(() {
    reset(MockGetPowerMeterDataUseCase());
  });

  test('3秒平均が正しく計算されること', () async {
    final mock = MockGetPowerMeterDataUseCase();
    final usecase = GetCalculatedPowerMeterDataUseCase(mock);
    // モックのストリームデータを用意
    final inputStream = Stream.fromIterable([
      PowerMeterData(power: 100, cadence: 80), // 1秒目
      PowerMeterData(power: 200, cadence: 90), // 2秒目
      PowerMeterData(power: 300, cadence: 100), // 3秒目
      PowerMeterData(power: 400, cadence: 110), // 4秒目
    ]);
    // モックの振る舞いを定義
    when(mock()).thenAnswer((_) => inputStream);

    // 実行
    final resultStream = usecase();
    final results = await resultStream.toList();

    // 結果を検証
    expect(results.length, 4); // 入力データ数と一致する

    // 期待される3秒平均値
    expect(results[0], PowerMeterData(power: 100, cadence: 80)); // 1秒目 (1データだけ)
    expect(
        results[1], PowerMeterData(power: 150, cadence: 85)); // 2秒目 (2データの平均)
    expect(
        results[2], PowerMeterData(power: 200, cadence: 90)); // 3秒目 (3データの平均)
    expect(results[3],
        PowerMeterData(power: 300, cadence: 100)); // 4秒目 (最新3データの平均)
  });
}
