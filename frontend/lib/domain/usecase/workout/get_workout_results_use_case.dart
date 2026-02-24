import 'package:workoutride/domain/model/workout/workout_result.dart';
import 'package:workoutride/domain/repository/workout_repository.dart';

class GetWorkoutResultsUseCase {
  final WorkoutRepository _repository;

  GetWorkoutResultsUseCase(this._repository);

  Future<List<WorkoutResult>> call() {
    return _repository.getWorkoutResults();
  }
}
