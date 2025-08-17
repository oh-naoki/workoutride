import 'package:workoutride/data/remote/workout_remote_data_source.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/workout/workout_summary.dart';
import 'package:workoutride/domain/repository/workout_repository.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutRemoteDataSource _remoteDataSource;

  WorkoutRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<WorkoutSummary>> getWorkoutSummaries() {
    return _remoteDataSource.getWorkoutSummaries();
  }

  @override
  Future<WorkoutSummary?> getWorkoutSummary(int workoutId) {
    return _remoteDataSource.getWorkoutSummary(workoutId);
  }

  @override
  Future<List<WorkoutBlock>> getWorkoutBlocks(int workoutId) {
    return _remoteDataSource.getWorkoutBlocks(workoutId);
  }
}
