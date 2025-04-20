import 'package:workoutride/data/remote/api/workout_api_client.dart';
import 'package:workoutride/data/remote/model/extensions.dart';
import 'package:workoutride/data/remote/model/workout_block_dto.dart';
import 'package:workoutride/data/remote/model/workout_summary_dto.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/workout/workout_summary.dart';

class WorkoutRemoteDataSource {
  final WorkoutApiClient _apiClient;

  WorkoutRemoteDataSource(this._apiClient);

  Future<List<WorkoutSummary>> getWorkoutSummaries() async {
    final List<WorkoutSummaryDto> summaries = await _apiClient.getWorkoutSummaries();
    return summaries.map((e) => e.toDomain()).toList();
  }

  Future<List<WorkoutBlock>> getWorkoutBlocks(int workoutId) async {
    final List<WorkoutBlockDto> blocks = await _apiClient.getWorkoutBlocks(workoutId);
    return blocks.map((e) => e.toDomain()).toList();
  }
}
