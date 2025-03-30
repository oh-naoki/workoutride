import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:workoutride/data/ble_connector.dart';
import 'package:workoutride/domain/usecase/get_power_meter_data_use_case.dart';

import 'get_power_meter_data_use_case_test.mocks.dart';

@GenerateMocks([BleConnector])
void main() {
  late MockBleConnector mockBleConnector;

  setUp(() {
    mockBleConnector = MockBleConnector();
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
      test('should subscribe to BLE connector notifications for power meter characteristic', () {
        // Arrange
        final useCase = GetPowerMeterDataUseCase(mockBleConnector);
        when(mockBleConnector.notify("2A63")).thenAnswer((_) => const Stream.empty());

        // Act
        useCase.call();

        // Assert
        verify(mockBleConnector.notify("2A63")).called(1);
      });
    });

    // Test group for data processing
    group('Data Processing', () {
      test('should correctly parse basic power data with flags and power value', () {
        // Arrange
        final useCase = GetPowerMeterDataUseCase(mockBleConnector);
        final data = testData['basicPowerData']!;

        // Act
        final result = useCase.processData(data);

        // Assert
        expect(result.power, equals(200));
        expect(result.cadence, equals(0));
      });

      test('should correctly parse power data with balance information', () {
        // Arrange
        final useCase = GetPowerMeterDataUseCase(mockBleConnector);
        final data = testData['powerBalanceData']!;

        // Act
        final result = useCase.processData(data);

        // Assert
        expect(result.power, equals(200));
        expect(result.cadence, equals(0));
      });

      test('should correctly calculate cadence from crank revolution data and time', () {
        // Arrange
        final useCase = GetPowerMeterDataUseCase(mockBleConnector);
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
        final useCase = GetPowerMeterDataUseCase(mockBleConnector);
        final data = testData['emptyData']!;

        // Act
        final result = useCase.processData(data);

        // Assert
        expect(result.power, equals(0));
        expect(result.cadence, equals(0));
      });

      test('should handle invalid data format', () {
        // Arrange
        final useCase = GetPowerMeterDataUseCase(mockBleConnector);
        final data = testData['invalidData']!;

        // Act
        final result = useCase.processData(data);

        // Assert
        expect(result.power, equals(0));
        expect(result.cadence, equals(0));
      });

      test('should handle minimum and maximum power values', () {
        // Arrange
        final useCase = GetPowerMeterDataUseCase(mockBleConnector);
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
        final useCase = GetPowerMeterDataUseCase(mockBleConnector);

        // Act
        final result = useCase.processData([]);

        // Assert
        expect(result.power, equals(0));
        expect(result.cadence, equals(0));
      });

      test('should handle BLE connection error', () async {
        // Arrange
        final useCase = GetPowerMeterDataUseCase(mockBleConnector);
        when(mockBleConnector.notify("2A63")).thenThrow(Exception("BLE connection error"));

        // Act & Assert
        expect(() => useCase.call(), throwsException);
      });
    });
  });
}
