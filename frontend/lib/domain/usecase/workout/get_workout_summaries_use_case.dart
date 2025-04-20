import 'package:workoutride/domain/model/workout/workout_summary.dart';
import 'package:workoutride/domain/repository/workout_repository.dart';

class GetWorkoutSummariesUseCase {
  final WorkoutRepository _repository;

  GetWorkoutSummariesUseCase(this._repository);

  Future<List<WorkoutSummary>> call() async {
    return await _repository.getWorkoutSummaries();
  }
}
