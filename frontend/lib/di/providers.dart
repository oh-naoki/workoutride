import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workoutride/data/remote/api/auth_api_client.dart';
import 'package:workoutride/data/remote/api/workout_api_client.dart';
import 'package:workoutride/data/remote/api/user_ftp_api_client.dart';
import 'package:workoutride/data/remote/api/user_profile_api_client.dart';
import 'package:workoutride/data/remote/interceptor/auth_interceptor.dart';
import 'package:workoutride/data/remote/workout_remote_data_source.dart';
import 'package:workoutride/data/repository/auth_repository_impl.dart';
import 'package:workoutride/data/repository/workout_repository_impl.dart';
import 'package:workoutride/domain/repository/auth_repository.dart';
import 'package:workoutride/domain/repository/workout_repository.dart';
import 'package:workoutride/domain/usecase/workout/save_workout_result_use_case.dart';
import 'package:workoutride/data/ble_connector.dart';
import 'package:workoutride/data/power_meter_data_source.dart';
import 'package:workoutride/domain/model/mock_pattern.dart';
import 'package:workoutride/domain/usecase/workout/manage_workout_use_case.dart';
import 'package:workoutride/domain/usecase/get_calculated_power_meter_data_usecase.dart';
import 'package:workoutride/domain/service/power_zone_analyzer.dart';
import 'package:workoutride/domain/repository/user_profile_repository.dart';
import 'package:workoutride/data/repository/user_profile_repository_impl.dart';
import 'package:workoutride/domain/usecase/user_profile/get_user_profile_use_case.dart';
import 'package:workoutride/domain/usecase/user_profile/save_user_weight_use_case.dart';
import 'package:workoutride/domain/usecase/user_profile/get_user_ftp_use_case.dart';
import 'package:workoutride/domain/usecase/user_profile/save_user_ftp_use_case.dart';
import 'package:workoutride/domain/usecase/auto_connect_ble_power_meter_use_case.dart';
import 'package:workoutride/domain/usecase/connect_ble_power_meter_use_case.dart';
import 'package:workoutride/domain/usecase/scan_ble_device_usecase.dart';
import 'package:workoutride/domain/usecase/get_power_meter_data_use_case.dart';

part 'providers.g.dart';

const _mockModeKey = 'mock_mode';
const _mockPatternKey = 'mock_pattern';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError();
}

// Auth providers
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

@Riverpod(keepAlive: true)
GoogleSignIn googleSignIn(Ref ref) {
  return GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '432477473655-2ovs5abgvf6cu6ke9gli7b5phgi0je4u.apps.googleusercontent.com',
  );
}

@Riverpod(keepAlive: true)
AuthApiClient authApiClient(Ref ref) {
  return AuthApiClient(ref.watch(dioProvider));
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    ref.watch(authApiClientProvider),
    ref.watch(googleSignInProvider),
    ref.watch(secureStorageProvider),
  );
}

/// モックモードの ON/OFF。SharedPreferences に永続化する。
@riverpod
class MockMode extends _$MockMode {
  @override
  bool build() {
    return ref.watch(sharedPreferencesProvider).getBool(_mockModeKey) ?? false;
  }

  void toggle() {
    final next = !state;
    ref.read(sharedPreferencesProvider).setBool(_mockModeKey, next);
    state = next;
  }
}

/// モックパワーデータのパターン選択。SharedPreferences に永続化する。
@riverpod
class MockPatternSelection extends _$MockPatternSelection {
  @override
  MockPattern build() {
    final savedPattern =
        ref.watch(sharedPreferencesProvider).getString(_mockPatternKey);
    return savedPattern != null
        ? MockPattern.values.firstWhere(
            (p) => p.name == savedPattern,
            orElse: () => MockPattern.warmup,
          )
        : MockPattern.warmup;
  }

  void setPattern(MockPattern pattern) {
    ref
        .read(sharedPreferencesProvider)
        .setString(_mockPatternKey, pattern.name);
    state = pattern;
  }
}

const debugApiUrlKey = 'debug_api_url';

// DIプロバイダー
@riverpod
Dio dio(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final debugUrl = kDebugMode ? prefs.getString(debugApiUrlKey) : null;
  final baseUrl = debugUrl ?? dotenv.env['API_BASE_URL'];
  if (baseUrl == null || baseUrl.isEmpty) {
    throw Exception('API_BASE_URL is not set in .env file');
  }
  final dio = Dio(BaseOptions(baseUrl: baseUrl));

  // AuthInterceptorを追加
  dio.interceptors.add(
    AuthInterceptor(ref.read(secureStorageProvider), ref),
  );

  // iOSシミュレータでHTTPSを許可する設定
  dio.options.validateStatus = (status) {
    return status != null && status >= 200 && status < 400;
  };
  return dio;
}

@riverpod
WorkoutApiClient workoutApiClient(Ref ref) {
  return WorkoutApiClient(ref.read(dioProvider));
}

@riverpod
UserFtpApiClient userFtpApiClient(Ref ref) {
  return UserFtpApiClient(ref.read(dioProvider));
}

@riverpod
UserProfileApiClient userProfileApiClient(Ref ref) {
  return UserProfileApiClient(ref.read(dioProvider));
}

@riverpod
WorkoutRemoteDataSource workoutRemoteDataSource(Ref ref) {
  return WorkoutRemoteDataSource(ref.read(workoutApiClientProvider));
}

@riverpod
WorkoutRepository workoutRepository(Ref ref) {
  return WorkoutRepositoryImpl(ref.read(workoutRemoteDataSourceProvider));
}

@riverpod
PowerMeterDataSource powerMeterDataSource(Ref ref) {
  final isMockMode = ref.watch(mockModeProvider);
  final mockPattern = ref.watch(mockPatternSelectionProvider);

  if (isMockMode) {
    return MockPowerMeterDataSource(mockPattern);
  } else {
    return BlePowerMeterDataSource(ref.read(bleConnectorProvider));
  }
}

// User Profile providers
@riverpod
UserProfileRepository userProfileRepository(Ref ref) {
  return UserProfileRepositoryImpl(
    sharedPreferences: ref.read(sharedPreferencesProvider),
    userFtpApiClient: ref.read(userFtpApiClientProvider),
    userProfileApiClient: ref.read(userProfileApiClientProvider),
  );
}

@riverpod
GetUserProfileUseCase getUserProfileUseCase(Ref ref) {
  return GetUserProfileUseCase(
      repository: ref.read(userProfileRepositoryProvider));
}

@riverpod
SaveUserWeightUseCase saveUserWeightUseCase(Ref ref) {
  return SaveUserWeightUseCase(
      repository: ref.read(userProfileRepositoryProvider));
}

@riverpod
GetUserFtpUseCase getUserFtpUseCase(Ref ref) {
  return GetUserFtpUseCase(ref.read(userProfileRepositoryProvider));
}

@riverpod
SaveUserFtpUseCase saveUserFtpUseCase(Ref ref) {
  return SaveUserFtpUseCase(ref.read(userProfileRepositoryProvider));
}

@riverpod
AutoConnectBlePowerMeterUseCase autoConnectBlePowerMeterUseCase(Ref ref) {
  return AutoConnectBlePowerMeterUseCase(ref.read(bleConnectorProvider));
}

@riverpod
BleConnector bleConnector(Ref ref) {
  return BleConnector(ref.read(sharedPreferencesProvider));
}

@riverpod
ConnectBlePowerMeterUseCase connectBlePowerMeterUseCase(Ref ref) {
  return ConnectBlePowerMeterUseCase(ref.read(bleConnectorProvider));
}

@riverpod
ScanBleDeviceUseCase scanBleDeviceUseCase(Ref ref) {
  return ScanBleDeviceUseCase(ref.read(bleConnectorProvider));
}

@riverpod
GetPowerMeterDataUseCase getPowerMeterDataUseCase(Ref ref) {
  return GetPowerMeterDataUseCase(ref.read(powerMeterDataSourceProvider));
}

@riverpod
GetCalculatedPowerMeterDataUseCase getCalculatedPowerMeterDataUseCase(Ref ref) {
  return GetCalculatedPowerMeterDataUseCase(
      ref.read(getPowerMeterDataUseCaseProvider));
}

@riverpod
PowerZoneAnalyzer powerZoneAnalyzer(Ref ref) {
  return PowerZoneAnalyzer();
}

@riverpod
ManageWorkoutUseCase manageWorkoutUseCase(Ref ref) {
  return ManageWorkoutUseCase(
    ref.read(getCalculatedPowerMeterDataUseCaseProvider),
    ref.read(powerZoneAnalyzerProvider),
    ref.read(getUserFtpUseCaseProvider),
  );
}

@riverpod
SaveWorkoutResultUseCase saveWorkoutResultUseCase(Ref ref) {
  return SaveWorkoutResultUseCase(ref.read(workoutRepositoryProvider));
}
