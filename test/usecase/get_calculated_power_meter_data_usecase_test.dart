import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:workoutride/domain/model/power_meter_data.dart';
import 'package:workoutride/domain/usecase/get_calculated_power_meter_data_usecase.dart';
import 'package:workoutride/domain/usecase/get_power_meter_data_use_case.dart';

import 'get_calculated_power_meter_data_usecase_test.mocks.dart';

@GenerateMocks([GetPowerMeterDataUseCase])
void main() {
  late GetCalculatedPowerMeterDataUseCase useCase;
  late MockGetPowerMeterDataUseCase mockGetPowerMeterDataUseCase;

  setUp(() {
    mockGetPowerMeterDataUseCase = MockGetPowerMeterDataUseCase();
    useCase = GetCalculatedPowerMeterDataUseCase(mockGetPowerMeterDataUseCase);
  });

  test('3件未満のデータの場合、平均値を正しく計算する', () async {
    // Arrange
    final testData = [
      const PowerMeterData(power: 100, cadence: 80),
      const PowerMeterData(power: 200, cadence: 90),
    ];
    when(mockGetPowerMeterDataUseCase())
        .thenAnswer((_) => Stream.fromIterable(testData));

    // Act
    final results = await useCase().toList();

    // Assert
    expect(results.length, 2);
    expect(results[0].power, 100);
    expect(results[0].cadence, 80);
    expect(results[1].power, 150);
    expect(results[1].cadence, 85);
  });

  test('3件のデータの場合、平均値を正しく計算する', () async {
    // Arrange
    final testData = [
      const PowerMeterData(power: 100, cadence: 80),
      const PowerMeterData(power: 200, cadence: 90),
      const PowerMeterData(power: 300, cadence: 100),
    ];
    when(mockGetPowerMeterDataUseCase())
        .thenAnswer((_) => Stream.fromIterable(testData));

    // Act
    final results = await useCase().toList();

    // Assert
    expect(results.length, 3);
    expect(results[2].power, 200);
    expect(results[2].cadence, 90);
  });

  test('3件を超えるデータの場合、古いデータを削除して平均値を計算する', () async {
    // Arrange
    final testData = [
      const PowerMeterData(power: 100, cadence: 80),
      const PowerMeterData(power: 200, cadence: 90),
      const PowerMeterData(power: 300, cadence: 100),
      const PowerMeterData(power: 400, cadence: 110),
    ];
    when(mockGetPowerMeterDataUseCase())
        .thenAnswer((_) => Stream.fromIterable(testData));

    // Act
    final results = await useCase().toList();

    // Assert
    expect(results.length, 4);
    expect(results[3].power, 300);
    expect(results[3].cadence, 100);
  });

  test('異なるパワーとケイデンス値の組み合わせを正しく処理する', () async {
    // Arrange
    final testData = [
      const PowerMeterData(power: 150, cadence: 85),
      const PowerMeterData(power: 250, cadence: 95),
      const PowerMeterData(power: 350, cadence: 105),
    ];
    when(mockGetPowerMeterDataUseCase())
        .thenAnswer((_) => Stream.fromIterable(testData));

    // Act
    final results = await useCase().toList();

    // Assert
    expect(results.length, 3);
    expect(results[2].power, 250);
    expect(results[2].cadence, 95);
  });
}
