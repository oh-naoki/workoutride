import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/repository/workout_repository.dart';

class GetWorkoutBlocksUseCase {
  final WorkoutRepository _repository;

  GetWorkoutBlocksUseCase(this._repository);

  Future<List<WorkoutBlock>> call(int workoutId) async {
    return await _repository.getWorkoutBlocks(workoutId);
  }
}
