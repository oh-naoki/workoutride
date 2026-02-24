import 'package:workoutride/data/remote/api/workout_api_client.dart';
import 'package:workoutride/data/remote/model/extensions.dart';
import 'package:workoutride/data/remote/model/save_workout_result_request.dart';
import 'package:workoutride/data/remote/model/workout_block_dto.dart';
import 'package:workoutride/data/remote/model/workout_result_dto.dart';
import 'package:workoutride/data/remote/model/workout_summary_dto.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/workout/workout_result.dart';
import 'package:workoutride/domain/model/workout/workout_summary.dart';

class WorkoutRemoteDataSource {
  final WorkoutApiClient _apiClient;

  WorkoutRemoteDataSource(this._apiClient);

  Future<List<WorkoutSummary>> getWorkoutSummaries() async {
    final List<WorkoutSummaryDto> summaries = await _apiClient.getWorkoutSummaries();
    return summaries.map((e) => e.toDomain()).toList();
  }

  Future<List<WorkoutBlock>> getWorkoutBlocks(int workoutSummaryId) async {
    final List<WorkoutBlockDto> blocks = await _apiClient.getWorkoutBlocks(workoutSummaryId);
    return blocks.map((e) => e.toDomain()).toList();
  }

  Future<List<WorkoutResult>> getWorkoutResults() async {
    final List<WorkoutResultDto> results = await _apiClient.getWorkoutResults();
    return results.map((e) => e.toDomain()).toList();
  }

  Future<WorkoutResult> getWorkoutResult(int id) async {
    final WorkoutResultDto result = await _apiClient.getWorkoutResult(id);
    return result.toDomain();
  }

  Future<WorkoutResult> saveWorkoutResult(SaveWorkoutResultRequest request) async {
    final WorkoutResultDto result = await _apiClient.saveWorkoutResult(request.toJson());
    return result.toDomain();
  }
}
