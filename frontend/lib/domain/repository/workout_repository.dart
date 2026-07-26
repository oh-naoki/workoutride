import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/workout/workout_result.dart';
import 'package:workoutride/domain/model/workout/workout_result_draft.dart';
import 'package:workoutride/domain/model/workout/workout_summary.dart';

abstract class WorkoutRepository {
  Future<List<WorkoutSummary>> getWorkoutSummaries();
  Future<WorkoutSummary> getWorkoutSummary(int id);
  Future<List<WorkoutBlock>> getWorkoutBlocks(int workoutSummaryId);
  Future<List<WorkoutResult>> getWorkoutResults();
  Future<WorkoutResult> getWorkoutResult(int id);
  Future<WorkoutResult> saveWorkoutResult(WorkoutResultDraft draft);
}
