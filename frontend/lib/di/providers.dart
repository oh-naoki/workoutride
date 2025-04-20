import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workoutride/data/remote/api/workout_api_client.dart';
import 'package:workoutride/data/remote/workout_remote_data_source.dart';
import 'package:workoutride/data/repository/workout_repository_impl.dart';
import 'package:workoutride/domain/repository/workout_repository.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_blocks_use_case.dart';
import 'package:workoutride/domain/usecase/workout/get_workout_summaries_use_case.dart';

part 'providers.g.dart';

// UseCaseプロバイダー
@riverpod
GetWorkoutSummariesUseCase getWorkoutSummariesUseCase(GetWorkoutSummariesUseCaseRef ref) {
  return GetWorkoutSummariesUseCase(ref.read(workoutRepositoryProvider));
}

@riverpod
GetWorkoutBlocksUseCase getWorkoutBlocksUseCase(GetWorkoutBlocksUseCaseRef ref) {
  return GetWorkoutBlocksUseCase(ref.read(workoutRepositoryProvider));
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
