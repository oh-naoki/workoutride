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
import 'package:workoutride/data/remote/interceptor/auth_interceptor.dart';
import 'package:workoutride/data/remote/workout_remote_data_source.dart';
import 'package:workoutride/data/repository/auth_repository_impl.dart';
import 'package:workoutride/data/repository/workout_repository_impl.dart';
import 'package:workoutride/domain/repository/auth_repository.dart';
import 'package:workoutride/domain/repository/workout_repository.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_blocks_use_case.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_results_use_case.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_summaries_use_case.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_summary_use_case.dart';
import 'package:workoutride/domain/usecase/workout/save_workout_result_use_case.dart';
import 'package:workoutride/data/ble_connector.dart';
import 'package:workoutride/data/power_meter_data_source.dart';
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
    serverClientId: '432477473655-2ovs5abgvf6cu6ke9gli7b5phgi0je4u.apps.googleusercontent.com',
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

class MockModeStateNotifier extends StateNotifier<bool> {
  final SharedPreferences _sharedPreferences;
  
  MockModeStateNotifier(this._sharedPreferences) 
    : super(_sharedPreferences.getBool(_mockModeKey) ?? false);

  bool get value => state;

  void toggle() {
    state = !state;
    _sharedPreferences.setBool(_mockModeKey, state);
  }
}

class MockPatternStateNotifier extends StateNotifier<MockPattern> {
  final SharedPreferences _sharedPreferences;
  
  MockPatternStateNotifier(this._sharedPreferences) 
    : super(_getInitialPattern(_sharedPreferences));

  static MockPattern _getInitialPattern(SharedPreferences prefs) {
    final savedPattern = prefs.getString(_mockPatternKey);
    return savedPattern != null 
      ? MockPattern.values.firstWhere((p) => p.name == savedPattern)
      : MockPattern.warmup;
  }

  MockPattern get value => state;

  void setPattern(MockPattern pattern) {
    state = pattern;
    _sharedPreferences.setString(_mockPatternKey, pattern.name);
  }
}

@riverpod
MockModeStateNotifier mockModeStateNotifier(Ref ref) {
  return MockModeStateNotifier(ref.read(sharedPreferencesProvider));
}

@riverpod
MockPatternStateNotifier mockPatternStateNotifier(Ref ref) {
  return MockPatternStateNotifier(ref.read(sharedPreferencesProvider));
}

// UseCaseプロバイダー
@riverpod
GetWorkoutSummariesUseCase getWorkoutSummariesUseCase(Ref ref) {
  return GetWorkoutSummariesUseCase(ref.read(workoutRepositoryProvider));
}

@riverpod
GetWorkoutBlocksUseCase getWorkoutBlocksUseCase(Ref ref) {
  return GetWorkoutBlocksUseCase(ref.read(workoutRepositoryProvider));
}

@riverpod
GetWorkoutSummaryUseCase getWorkoutSummaryUseCase(Ref ref) {
  return GetWorkoutSummaryUseCase(ref.read(workoutRepositoryProvider));
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
WorkoutRemoteDataSource workoutRemoteDataSource(Ref ref) {
  return WorkoutRemoteDataSource(ref.read(workoutApiClientProvider));
}

@riverpod
WorkoutRepository workoutRepository(Ref ref) {
  return WorkoutRepositoryImpl(ref.read(workoutRemoteDataSourceProvider));
}

@riverpod
PowerMeterDataSource powerMeterDataSource(Ref ref) {
  final mockModeNotifier = ref.watch(mockModeStateNotifierProvider);
  final mockPatternNotifier = ref.watch(mockPatternStateNotifierProvider);
  
  if (mockModeNotifier.value) {
    return MockPowerMeterDataSource(mockPatternNotifier.value);
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
  );
}

@riverpod
GetUserProfileUseCase getUserProfileUseCase(Ref ref) {
  return GetUserProfileUseCase(repository: ref.read(userProfileRepositoryProvider));
}

@riverpod
SaveUserWeightUseCase saveUserWeightUseCase(Ref ref) {
  return SaveUserWeightUseCase(repository: ref.read(userProfileRepositoryProvider));
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
  return GetCalculatedPowerMeterDataUseCase(ref.read(getPowerMeterDataUseCaseProvider));
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
    ref.read(getUserProfileUseCaseProvider),
  );
}

@riverpod
SaveWorkoutResultUseCase saveWorkoutResultUseCase(Ref ref) {
  return SaveWorkoutResultUseCase(ref.read(workoutRepositoryProvider));
}

@riverpod
GetWorkoutResultsUseCase getWorkoutResultsUseCase(Ref ref) {
  return GetWorkoutResultsUseCase(ref.read(workoutRepositoryProvider));
}


