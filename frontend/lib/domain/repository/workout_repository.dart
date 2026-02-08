import 'package:workoutride/data/remote/model/save_workout_result_request.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/workout/workout_result.dart';
import 'package:workoutride/domain/model/workout/workout_summary.dart';

abstract class WorkoutRepository {
  Future<List<WorkoutSummary>> getWorkoutSummaries();
  Future<List<WorkoutBlock>> getWorkoutBlocks(int workoutSummaryId);
  Future<List<WorkoutResult>> getWorkoutResults();
  Future<WorkoutResult> getWorkoutResult(int id);
  Future<WorkoutResult> saveWorkoutResult(SaveWorkoutResultRequest request);
}
