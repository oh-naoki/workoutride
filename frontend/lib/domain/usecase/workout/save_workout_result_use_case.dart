import 'package:workoutride/data/remote/model/save_workout_result_request.dart';
import 'package:workoutride/domain/model/workout/workout_result.dart';
import 'package:workoutride/domain/repository/workout_repository.dart';

class SaveWorkoutResultUseCase {
  final WorkoutRepository _repository;

  SaveWorkoutResultUseCase(this._repository);

  Future<WorkoutResult> call(SaveWorkoutResultRequest request) {
    return _repository.saveWorkoutResult(request);
  }
}
