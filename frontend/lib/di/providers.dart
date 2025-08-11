import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workoutride/data/remote/api/workout_api_client.dart';
import 'package:workoutride/data/remote/workout_remote_data_source.dart';
import 'package:workoutride/data/repository/workout_repository_impl.dart';
import 'package:workoutride/domain/repository/workout_repository.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_blocks_use_case.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_summaries_use_case.dart';
import 'package:workoutride/data/ble_connector.dart';
import 'package:workoutride/data/power_meter_data_source.dart';
import 'package:workoutride/domain/usecase/workout/manage_workout_use_case.dart';
import 'package:workoutride/domain/usecase/get_calculated_power_meter_data_usecase.dart';
import 'package:workoutride/domain/service/power_zone_analyzer.dart';
import 'package:workoutride/domain/repository/user_profile_repository.dart';
import 'package:workoutride/data/repository/user_profile_repository_impl.dart';
import 'package:workoutride/domain/usecase/user_profile/get_user_profile_use_case.dart';
import 'package:workoutride/domain/usecase/user_profile/save_user_weight_use_case.dart';
import 'package:workoutride/domain/usecase/auto_connect_ble_power_meter_use_case.dart';

part 'providers.g.dart';

const _mockModeKey = 'mock_mode';
const _mockPatternKey = 'mock_pattern';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError();
}

@Riverpod(keepAlive: true)
class MockModeState extends _$MockModeState {
  @override
  bool build() {
    // SharedPreferencesから初期値を読み込む
    return ref.read(sharedPreferencesProvider).getBool(_mockModeKey) ?? false;
  }

  void toggle() {
    state = !state;
    // 状態を永続化
    ref.read(sharedPreferencesProvider).setBool(_mockModeKey, state);
  }
}

@Riverpod(keepAlive: true)
class MockPatternState extends _$MockPatternState {
  @override
  MockPattern build() {
    // SharedPreferencesから初期値を読み込む
    final savedPattern = ref.read(sharedPreferencesProvider).getString(_mockPatternKey);
    return savedPattern != null 
      ? MockPattern.values.firstWhere((p) => p.name == savedPattern)
      : MockPattern.warmup;
  }

  void setPattern(MockPattern pattern) {
    state = pattern;
    // 状態を永続化
    ref.read(sharedPreferencesProvider).setString(_mockPatternKey, pattern.name);
  }
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
ManageWorkoutUseCase manageWorkoutUseCase(ManageWorkoutUseCaseRef ref) {
  return ManageWorkoutUseCase(
    ref.watch(getCalculatedPowerMeterDataUseCaseProvider),
    ref.watch(powerZoneAnalyzerProvider),
    ref.watch(getUserProfileUseCaseProvider),
  );
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
  final isMock = ref.watch(mockModeStateProvider);
  if (isMock) {
    final pattern = ref.watch(mockPatternStateProvider);
    return MockPowerMeterDataSource(pattern);
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
AutoConnectBlePowerMeterUseCase autoConnectBlePowerMeterUseCase(AutoConnectBlePowerMeterUseCaseRef ref) {
  return AutoConnectBlePowerMeterUseCase(ref.read(bleConnectorProvider));
}
