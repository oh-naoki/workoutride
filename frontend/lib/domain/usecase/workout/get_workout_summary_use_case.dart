import 'package:workoutride/domain/model/workout/workout_summary.dart';
import 'package:workoutride/domain/repository/workout_repository.dart';

class GetWorkoutSummaryUseCase {
  final WorkoutRepository _repository;

  GetWorkoutSummaryUseCase(this._repository);

  Future<WorkoutSummary> call(int id) async {
    return await _repository.getWorkoutSummary(id);
  }
}
