import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:workoutride/data/power_meter_data_source.dart';
import 'package:workoutride/domain/usecase/get_power_meter_data_use_case.dart';

import 'get_power_meter_data_use_case_test.mocks.dart' as mocks;

@GenerateMocks([PowerMeterDataSource])
void main() {
  late mocks.MockPowerMeterDataSource mockPowerMeterDataSource;

  setUp(() {
    mockPowerMeterDataSource = mocks.MockPowerMeterDataSource();
  });

  // Test data constants
  const Map<String, List<int>> testData = {
    'basicPowerData': [0x00, 0x00, 0xC8, 0x00], // Flags: 0x0000, Power: 200 W
    'powerBalanceData': [0x01, 0x00, 0xC8, 0x00, 0x50], // Flags: 0x0001, Power: 200 W, Balance: 80%
    'initialCrankData': [0x20, 0x00, 0xC8, 0x00, 0x00, 0x00, 0x00, 0x00], // Initial data
    'crankDataWithRevs': [0x20, 0x00, 0xC8, 0x00, 0x0A, 0x00, 0x00, 0x20], // 10 revs, 8192 ms (8 sec)
    'minPowerData': [0x00, 0x00, 0x00, 0x00], // Power: 0 W
    'maxPowerData': [0x00, 0x00, 0xFF, 0xFF], // Power: 65535 W
    'invalidData': [0x00, 0x00], // Incomplete data
    'emptyData': <int>[],
  };

  group('GetPowerMeterDataUseCase', () {
    // Test group for BLE connection
    group('BLE Connection', () {
      test('should subscribe to power meter data source for raw data', () {
        // Arrange
        final useCase = GetPowerMeterDataUseCase(mockPowerMeterDataSource);
        when(mockPowerMeterDataSource.getRawData()).thenAnswer((_) => const Stream.empty());

        // Act
        useCase.call();

        // Assert
        verify(mockPowerMeterDataSource.getRawData()).called(1);
      });
    });

    // Test group for data processing
    group('Data Processing', () {
      test('should correctly parse basic power data with flags and power value', () {
        // Arrange
        final useCase = GetPowerMeterDataUseCase(mockPowerMeterDataSource);
        final data = testData['basicPowerData']!;

        // Act
        final result = useCase.processData(data);

        // Assert
        expect(result.power, equals(200));
        expect(result.cadence, equals(0));
      });

      test('should correctly parse power data with balance information', () {
        // Arrange
        final useCase = GetPowerMeterDataUseCase(mockPowerMeterDataSource);
        final data = testData['powerBalanceData']!;

        // Act
        final result = useCase.processData(data);

        // Assert
        expect(result.power, equals(200));
        expect(result.cadence, equals(0));
      });

      test('should correctly calculate cadence from crank revolution data and time', () {
        // Arrange
        final useCase = GetPowerMeterDataUseCase(mockPowerMeterDataSource);
        final data1 = testData['initialCrankData']!;
        final data2 = testData['crankDataWithRevs']!;

        // Act
        // Process first data (should initialize state)
        useCase.processData(data1);
        
        // Process second data (should calculate cadence)
        final result = useCase.processData(data2);

        // Assert
        expect(result.power, equals(200));
        expect(result.cadence, equals(75)); // 10 revs / 8 sec * 60 = 75 rpm
      });

      test('should handle empty data', () {
        // Arrange
        final useCase = GetPowerMeterDataUseCase(mockPowerMeterDataSource);
        final data = testData['emptyData']!;

        // Act
        final result = useCase.processData(data);

        // Assert
        expect(result.power, equals(0));
        expect(result.cadence, equals(0));
      });

      test('should handle invalid data format', () {
        // Arrange
        final useCase = GetPowerMeterDataUseCase(mockPowerMeterDataSource);
        final data = testData['invalidData']!;

        // Act
        final result = useCase.processData(data);

        // Assert
        expect(result.power, equals(0));
        expect(result.cadence, equals(0));
      });

      test('should handle minimum and maximum power values', () {
        // Arrange
        final useCase = GetPowerMeterDataUseCase(mockPowerMeterDataSource);
        final minPowerData = testData['minPowerData']!;
        final maxPowerData = testData['maxPowerData']!;

        // Act
        final minResult = useCase.processData(minPowerData);
        final maxResult = useCase.processData(maxPowerData);

        // Assert
        expect(minResult.power, equals(0));
        expect(maxResult.power, equals(65535));
      });
    });

    // Test group for error handling
    group('Error Handling', () {
      test('should handle null data', () {
        // Arrange
        final useCase = GetPowerMeterDataUseCase(mockPowerMeterDataSource);

        // Act
        final result = useCase.processData([]);

        // Assert
        expect(result.power, equals(0));
        expect(result.cadence, equals(0));
      });

      test('should handle power meter data source error', () async {
        // Arrange
        final useCase = GetPowerMeterDataUseCase(mockPowerMeterDataSource);
        when(mockPowerMeterDataSource.getRawData()).thenThrow(Exception("Data source error"));

        // Act & Assert
        expect(() => useCase.call(), throwsException);
      });
    });

    // ケイデンスが一瞬だけ落ちる不具合の回帰テスト
    group('Cadence stability', () {
      // Crank Revolution Data 付きのパケットを生成するヘルパー
      List<int> crankPacket({
        required int power,
        required int revs,
        required int time,
      }) =>
          [
            0x20, 0x00, // flags: Crank Revolution Data あり
            power & 0xFF, (power >> 8) & 0xFF,
            revs & 0xFF, (revs >> 8) & 0xFF,
            time & 0xFF, (time >> 8) & 0xFF,
          ];

      test('新しいクランクイベントが無い通知では直前のケイデンスを保持する', () {
        // Arrange
        var clock = DateTime(2026, 1, 1);
        final useCase = GetPowerMeterDataUseCase(
          mockPowerMeterDataSource,
          now: () => clock,
        );

        // Act
        // 基準パケット（初回は差分を計算できないので0）
        useCase.processData(crankPacket(power: 200, revs: 0, time: 0));
        // 3回転 / 2秒 → 90rpm
        final r1 = useCase.processData(crankPacket(power: 200, revs: 3, time: 2048));
        // 同じクランクデータ（新イベントなし）が1秒後に届く
        clock = clock.add(const Duration(seconds: 1));
        final r2 = useCase.processData(crankPacket(power: 200, revs: 3, time: 2048));

        // Assert
        expect(r1.cadence, equals(90));
        // 0 に落とさず 90 を保持する（平均のディップ＝一瞬60rpm等を防ぐ）
        expect(r2.cadence, equals(90));
      });

      test('一定時間クランクイベントが無ければケイデンスは0になる', () {
        // Arrange
        var clock = DateTime(2026, 1, 1);
        final useCase = GetPowerMeterDataUseCase(
          mockPowerMeterDataSource,
          now: () => clock,
        );

        // Act
        useCase.processData(crankPacket(power: 200, revs: 0, time: 0));
        final r1 = useCase.processData(crankPacket(power: 200, revs: 3, time: 2048));
        // しきい値(3秒)を超えて新イベントが来ない → 停止とみなす
        clock = clock.add(const Duration(seconds: 4));
        final r2 = useCase.processData(crankPacket(power: 200, revs: 3, time: 2048));

        // Assert
        expect(r1.cadence, equals(90));
        expect(r2.cadence, equals(0));
      });

      test('クランクイベント時刻の16bitラップアラウンドを跨いでも正しく計算する', () {
        // Arrange
        final useCase = GetPowerMeterDataUseCase(mockPowerMeterDataSource);

        // Act
        // 基準: time=65000 (残り 536 でラップ)
        useCase.processData(crankPacket(power: 200, revs: 100, time: 65000));
        // 65000 + 2048 = 67048 → 65536 で一周し 1512
        final result = useCase.processData(crankPacket(power: 200, revs: 103, time: 1512));

        // Assert
        // 3回転 / 2秒 = 90rpm（マスクしないと timeDiff が巨大な負数になり破綻する）
        expect(result.cadence, equals(90));
      });

      test('累積回転数の16bitラップアラウンドを跨いでも正しく計算する', () {
        // Arrange
        final useCase = GetPowerMeterDataUseCase(mockPowerMeterDataSource);

        // Act
        // 基準: revs=65535
        useCase.processData(crankPacket(power: 200, revs: 65535, time: 0));
        // 65535 + 3 = 65538 → 一周して 2
        final result = useCase.processData(crankPacket(power: 200, revs: 2, time: 2048));

        // Assert
        expect(result.cadence, equals(90));
      });
    });
  });
}
