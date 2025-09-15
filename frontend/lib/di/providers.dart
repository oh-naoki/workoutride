import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workoutride/data/remote/api/workout_api_client.dart';
import 'package:workoutride/data/remote/workout_remote_data_source.dart';
import 'package:workoutride/data/repository/workout_repository_impl.dart';
import 'package:workoutride/domain/repository/workout_repository.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_blocks_use_case.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_summaries_use_case.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_summary_use_case.dart';
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
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError();
}

class MockModeStateNotifier extends StateNotifier<bool> {
  final SharedPreferences _sharedPreferences;
  
  MockModeStateNotifier(this._sharedPreferences) 
    : super(_sharedPreferences.getBool(_mockModeKey) ?? false);

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

  void setPattern(MockPattern pattern) {
    state = pattern;
    _sharedPreferences.setString(_mockPatternKey, pattern.name);
  }
}

@riverpod
MockModeStateNotifier mockModeStateNotifier(MockModeStateNotifierRef ref) {
  return MockModeStateNotifier(ref.read(sharedPreferencesProvider));
}

@riverpod
MockPatternStateNotifier mockPatternStateNotifier(MockPatternStateNotifierRef ref) {
  return MockPatternStateNotifier(ref.read(sharedPreferencesProvider));
}

// UseCaseプロバイダー
@riverpod
GetWorkoutSummariesUseCase getWorkoutSummariesUseCase(GetWorkoutSummariesUseCaseRef ref) {
  return GetWorkoutSummariesUseCase(ref.read(workoutRepositoryProvider));
}

@riverpod
GetWorkoutBlocksUseCase getWorkoutBlocksUseCase(GetWorkoutBlocksUseCaseRef ref) {
  return GetWorkoutBlocksUseCase(ref.read(workoutRepositoryProvider));
}

@riverpod
GetWorkoutSummaryUseCase getWorkoutSummaryUseCase(GetWorkoutSummaryUseCaseRef ref) {
  return GetWorkoutSummaryUseCase(ref.read(workoutRepositoryProvider));
}

// DIプロバイダー
@riverpod
Dio dio(DioRef ref) {
  final dio = Dio();
  // iOSシミュレータでHTTPSを許可する設定
  dio.options.validateStatus = (status) {
    return status != null && status >= 200 && status < 400;
  };
  return dio;
}

@riverpod
WorkoutApiClient workoutApiClient(WorkoutApiClientRef ref) {
  return WorkoutApiClient(ref.read(dioProvider));
}

@riverpod
WorkoutRemoteDataSource workoutRemoteDataSource(WorkoutRemoteDataSourceRef ref) {
  return WorkoutRemoteDataSource(ref.read(workoutApiClientProvider));
}

@riverpod
WorkoutRepository workoutRepository(WorkoutRepositoryRef ref) {
  return WorkoutRepositoryImpl(ref.read(workoutRemoteDataSourceProvider));
}

@riverpod
PowerMeterDataSource powerMeterDataSource(PowerMeterDataSourceRef ref) {
  final mockModeNotifier = ref.watch(mockModeStateNotifierProvider);
  final mockPatternNotifier = ref.watch(mockPatternStateNotifierProvider);
  
  if (mockModeNotifier.state) {
    return MockPowerMeterDataSource(mockPatternNotifier.state);
  } else {
    return BlePowerMeterDataSource(ref.read(bleConnectorProvider));
  }
}

// User Profile providers
@riverpod
UserProfileRepository userProfileRepository(UserProfileRepositoryRef ref) {
  return UserProfileRepositoryImpl(
    sharedPreferences: ref.read(sharedPreferencesProvider),
  );
}

@riverpod
GetUserProfileUseCase getUserProfileUseCase(GetUserProfileUseCaseRef ref) {
  return GetUserProfileUseCase(repository: ref.read(userProfileRepositoryProvider));
}

@riverpod
SaveUserWeightUseCase saveUserWeightUseCase(SaveUserWeightUseCaseRef ref) {
  return SaveUserWeightUseCase(repository: ref.read(userProfileRepositoryProvider));
}

@riverpod
GetUserFtpUseCase getUserFtpUseCase(GetUserFtpUseCaseRef ref) {
  return GetUserFtpUseCase(ref.read(userProfileRepositoryProvider));
}

@riverpod
SaveUserFtpUseCase saveUserFtpUseCase(SaveUserFtpUseCaseRef ref) {
  return SaveUserFtpUseCase(ref.read(userProfileRepositoryProvider));
}

@riverpod
AutoConnectBlePowerMeterUseCase autoConnectBlePowerMeterUseCase(AutoConnectBlePowerMeterUseCaseRef ref) {
  return AutoConnectBlePowerMeterUseCase(ref.read(bleConnectorProvider));
}

@riverpod
BleConnector bleConnector(BleConnectorRef ref) {
  return BleConnector(ref.read(sharedPreferencesProvider));
}

@riverpod
ConnectBlePowerMeterUseCase connectBlePowerMeterUseCase(ConnectBlePowerMeterUseCaseRef ref) {
  return ConnectBlePowerMeterUseCase(ref.read(bleConnectorProvider));
}

@riverpod
ScanBleDeviceUseCase scanBleDeviceUseCase(ScanBleDeviceUseCaseRef ref) {
  return ScanBleDeviceUseCase(ref.read(bleConnectorProvider));
}

@riverpod
GetPowerMeterDataUseCase getPowerMeterDataUseCase(GetPowerMeterDataUseCaseRef ref) {
  return GetPowerMeterDataUseCase(ref.read(powerMeterDataSourceProvider));
}

@riverpod
GetCalculatedPowerMeterDataUseCase getCalculatedPowerMeterDataUseCase(GetCalculatedPowerMeterDataUseCaseRef ref) {
  return GetCalculatedPowerMeterDataUseCase(ref.read(getPowerMeterDataUseCaseProvider));
}

@riverpod
PowerZoneAnalyzer powerZoneAnalyzer(PowerZoneAnalyzerRef ref) {
  return PowerZoneAnalyzer();
}

@riverpod
ManageWorkoutUseCase manageWorkoutUseCase(ManageWorkoutUseCaseRef ref) {
  return ManageWorkoutUseCase(
    ref.read(getCalculatedPowerMeterDataUseCaseProvider),
    ref.read(powerZoneAnalyzerProvider),
    ref.read(getUserProfileUseCaseProvider),
  );
}


