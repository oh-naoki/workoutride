import 'package:workoutride/data/remote/model/save_workout_result_request.dart';
import 'package:workoutride/data/remote/workout_remote_data_source.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/workout/workout_result.dart';
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
  Future<List<WorkoutBlock>> getWorkoutBlocks(int workoutSummaryId) {
    return _remoteDataSource.getWorkoutBlocks(workoutSummaryId);
  }

  @override
  Future<List<WorkoutResult>> getWorkoutResults() {
    return _remoteDataSource.getWorkoutResults();
  }

  @override
  Future<WorkoutResult> getWorkoutResult(int id) {
    return _remoteDataSource.getWorkoutResult(id);
  }

  @override
  Future<WorkoutResult> saveWorkoutResult(SaveWorkoutResultRequest request) {
    return _remoteDataSource.saveWorkoutResult(request);
  }
}
