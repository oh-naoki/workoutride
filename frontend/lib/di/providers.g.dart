// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'1a6250efdc19e86c923ceb598a77ff74d64378e6';

/// See also [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = Provider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = ProviderRef<SharedPreferences>;
String _$secureStorageHash() => r'a4f75721472cf77465bf47f759c90de5ca30856e';

/// See also [secureStorage].
@ProviderFor(secureStorage)
final secureStorageProvider = Provider<FlutterSecureStorage>.internal(
  secureStorage,
  name: r'secureStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$secureStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SecureStorageRef = ProviderRef<FlutterSecureStorage>;
String _$googleSignInHash() => r'2dec99a8802c975eeec410536ad2f49e337663dd';

/// See also [googleSignIn].
@ProviderFor(googleSignIn)
final googleSignInProvider = Provider<GoogleSignIn>.internal(
  googleSignIn,
  name: r'googleSignInProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$googleSignInHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GoogleSignInRef = ProviderRef<GoogleSignIn>;
String _$authApiClientHash() => r'786912ba8f721e3635d1d84130e3c732558b9aac';

/// See also [authApiClient].
@ProviderFor(authApiClient)
final authApiClientProvider = Provider<AuthApiClient>.internal(
  authApiClient,
  name: r'authApiClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authApiClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthApiClientRef = ProviderRef<AuthApiClient>;
String _$authSessionSignalHash() => r'76be16a6812bab6cac2fa3b625ae93ff1a552cad';

/// 401 を通信層から Repository へ橋渡しする器。両者とも data 層なので
/// この受け渡しは層をまたがない。
///
/// Copied from [authSessionSignal].
@ProviderFor(authSessionSignal)
final authSessionSignalProvider =
    AutoDisposeProvider<AuthSessionSignal>.internal(
  authSessionSignal,
  name: r'authSessionSignalProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authSessionSignalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthSessionSignalRef = AutoDisposeProviderRef<AuthSessionSignal>;
String _$authRepositoryHash() => r'ea5b0bcd3e0e8de51788bfc40db581e54da97ea7';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = AutoDisposeProvider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = AutoDisposeProviderRef<AuthRepository>;
String _$dioHash() => r'8f28a38fe3f07603306e3dae9843e7b8b0008535';

/// See also [dio].
@ProviderFor(dio)
final dioProvider = AutoDisposeProvider<Dio>.internal(
  dio,
  name: r'dioProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DioRef = AutoDisposeProviderRef<Dio>;
String _$workoutApiClientHash() => r'45c6243ec1dff56bb5cc98afb8798e80456e647a';

/// See also [workoutApiClient].
@ProviderFor(workoutApiClient)
final workoutApiClientProvider = AutoDisposeProvider<WorkoutApiClient>.internal(
  workoutApiClient,
  name: r'workoutApiClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workoutApiClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WorkoutApiClientRef = AutoDisposeProviderRef<WorkoutApiClient>;
String _$userFtpApiClientHash() => r'5c71de01d3995967008bdd4c1ff55789bb8092ee';

/// See also [userFtpApiClient].
@ProviderFor(userFtpApiClient)
final userFtpApiClientProvider = AutoDisposeProvider<UserFtpApiClient>.internal(
  userFtpApiClient,
  name: r'userFtpApiClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userFtpApiClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserFtpApiClientRef = AutoDisposeProviderRef<UserFtpApiClient>;
String _$userProfileApiClientHash() =>
    r'dd46e9fd52607d05822f88792001183ee72a2921';

/// See also [userProfileApiClient].
@ProviderFor(userProfileApiClient)
final userProfileApiClientProvider =
    AutoDisposeProvider<UserProfileApiClient>.internal(
  userProfileApiClient,
  name: r'userProfileApiClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userProfileApiClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserProfileApiClientRef = AutoDisposeProviderRef<UserProfileApiClient>;
String _$workoutRepositoryHash() => r'1adb603bcce7c2d729dbc6e986dcfef189282acc';

/// See also [workoutRepository].
@ProviderFor(workoutRepository)
final workoutRepositoryProvider =
    AutoDisposeProvider<WorkoutRepository>.internal(
  workoutRepository,
  name: r'workoutRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workoutRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WorkoutRepositoryRef = AutoDisposeProviderRef<WorkoutRepository>;
String _$powerMeterDataSourceHash() =>
    r'c54fc52ad72a8d545139b93b7c554f6363f836dd';

/// See also [powerMeterDataSource].
@ProviderFor(powerMeterDataSource)
final powerMeterDataSourceProvider =
    AutoDisposeProvider<PowerMeterRawDataSource>.internal(
  powerMeterDataSource,
  name: r'powerMeterDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$powerMeterDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PowerMeterDataSourceRef
    = AutoDisposeProviderRef<PowerMeterRawDataSource>;
String _$userProfileRepositoryHash() =>
    r'b98d37e395612d33a443cb8ef74fec7d4256dffa';

/// See also [userProfileRepository].
@ProviderFor(userProfileRepository)
final userProfileRepositoryProvider =
    AutoDisposeProvider<UserProfileRepository>.internal(
  userProfileRepository,
  name: r'userProfileRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userProfileRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserProfileRepositoryRef
    = AutoDisposeProviderRef<UserProfileRepository>;
String _$bleConnectorHash() => r'f29ddceb8cb911e65a208c82019df9d2d59d45ec';

/// See also [bleConnector].
@ProviderFor(bleConnector)
final bleConnectorProvider = AutoDisposeProvider<BleConnector>.internal(
  bleConnector,
  name: r'bleConnectorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$bleConnectorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BleConnectorRef = AutoDisposeProviderRef<BleConnector>;
String _$blePowerMeterRepositoryHash() =>
    r'26e7aa76f8481e13811209d13b78ce59228c7f82';

/// See also [blePowerMeterRepository].
@ProviderFor(blePowerMeterRepository)
final blePowerMeterRepositoryProvider =
    AutoDisposeProvider<BlePowerMeterRepository>.internal(
  blePowerMeterRepository,
  name: r'blePowerMeterRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$blePowerMeterRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BlePowerMeterRepositoryRef
    = AutoDisposeProviderRef<BlePowerMeterRepository>;
String _$getPowerMeterDataUseCaseHash() =>
    r'450656c932d98078f1e2ff2979da5ab1bc3f5003';

/// See also [getPowerMeterDataUseCase].
@ProviderFor(getPowerMeterDataUseCase)
final getPowerMeterDataUseCaseProvider =
    AutoDisposeProvider<GetPowerMeterDataUseCase>.internal(
  getPowerMeterDataUseCase,
  name: r'getPowerMeterDataUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getPowerMeterDataUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetPowerMeterDataUseCaseRef
    = AutoDisposeProviderRef<GetPowerMeterDataUseCase>;
String _$getCalculatedPowerMeterDataUseCaseHash() =>
    r'bbb4cb92ca490a5ef4836b9ebfedc34c6e6986d7';

/// See also [getCalculatedPowerMeterDataUseCase].
@ProviderFor(getCalculatedPowerMeterDataUseCase)
final getCalculatedPowerMeterDataUseCaseProvider =
    AutoDisposeProvider<GetCalculatedPowerMeterDataUseCase>.internal(
  getCalculatedPowerMeterDataUseCase,
  name: r'getCalculatedPowerMeterDataUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCalculatedPowerMeterDataUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetCalculatedPowerMeterDataUseCaseRef
    = AutoDisposeProviderRef<GetCalculatedPowerMeterDataUseCase>;
String _$powerZoneAnalyzerHash() => r'30e9c54ce85c6ea7e55c573af4963a1ea3e68569';

/// See also [powerZoneAnalyzer].
@ProviderFor(powerZoneAnalyzer)
final powerZoneAnalyzerProvider =
    AutoDisposeProvider<PowerZoneAnalyzer>.internal(
  powerZoneAnalyzer,
  name: r'powerZoneAnalyzerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$powerZoneAnalyzerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PowerZoneAnalyzerRef = AutoDisposeProviderRef<PowerZoneAnalyzer>;
String _$manageWorkoutUseCaseHash() =>
    r'c5adba8b20cb202cb2bcacb0c5f15e995c348cd5';

/// See also [manageWorkoutUseCase].
@ProviderFor(manageWorkoutUseCase)
final manageWorkoutUseCaseProvider =
    AutoDisposeProvider<ManageWorkoutUseCase>.internal(
  manageWorkoutUseCase,
  name: r'manageWorkoutUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$manageWorkoutUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ManageWorkoutUseCaseRef = AutoDisposeProviderRef<ManageWorkoutUseCase>;
String _$workoutSoundPlayerHash() =>
    r'5b931f39255f57f8816605e3a838559fd075b3b1';

/// See also [workoutSoundPlayer].
@ProviderFor(workoutSoundPlayer)
final workoutSoundPlayerProvider =
    AutoDisposeProvider<WorkoutSoundPlayer>.internal(
  workoutSoundPlayer,
  name: r'workoutSoundPlayerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workoutSoundPlayerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WorkoutSoundPlayerRef = AutoDisposeProviderRef<WorkoutSoundPlayer>;
String _$mockModeHash() => r'4318c20e2959d772a2fa645299853f362d97412f';

/// モックモードの ON/OFF。SharedPreferences に永続化する。
///
/// Copied from [MockMode].
@ProviderFor(MockMode)
final mockModeProvider = AutoDisposeNotifierProvider<MockMode, bool>.internal(
  MockMode.new,
  name: r'mockModeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mockModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MockMode = AutoDisposeNotifier<bool>;
String _$mockPatternSelectionHash() =>
    r'8acdfc8ef3488da3130279d84c602543e2192277';

/// モックパワーデータのパターン選択。SharedPreferences に永続化する。
///
/// Copied from [MockPatternSelection].
@ProviderFor(MockPatternSelection)
final mockPatternSelectionProvider =
    AutoDisposeNotifierProvider<MockPatternSelection, MockPattern>.internal(
  MockPatternSelection.new,
  name: r'mockPatternSelectionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mockPatternSelectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MockPatternSelection = AutoDisposeNotifier<MockPattern>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
