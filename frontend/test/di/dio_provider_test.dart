import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workoutride/di/providers.dart';

void main() {
  group('dioProvider', () {
    test('throws when API_BASE_URL is not set', () async {
      dotenv.testLoad(fileInput: '');
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(const FlutterSecureStorage()),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      expect(
        () => container.read(dioProvider),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('API_BASE_URL is not set'),
        )),
      );
    });

    test('throws when API_BASE_URL is blank', () async {
      dotenv.testLoad(fileInput: 'API_BASE_URL=');
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(const FlutterSecureStorage()),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      expect(
        () => container.read(dioProvider),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('API_BASE_URL is not set'),
        )),
      );
    });

    test('succeeds when API_BASE_URL is set', () async {
      dotenv.testLoad(fileInput: 'API_BASE_URL=https://example.com');
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(const FlutterSecureStorage()),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);
      expect(dio.options.baseUrl, equals('https://example.com'));
    });
  });
}
