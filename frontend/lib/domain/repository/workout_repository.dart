import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/workout/workout_summary.dart';

abstract class WorkoutRepository {
  Future<List<WorkoutSummary>> getWorkoutSummaries();
  Future<List<WorkoutBlock>> getWorkoutBlocks(int workoutId);
}
