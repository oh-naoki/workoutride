import 'package:workoutride/domain/repository/user_profile_repository.dart';

class SaveUserWeightUseCase {
  final UserProfileRepository repository;

  SaveUserWeightUseCase({required this.repository});

  Future<void> call(double weight) async {
    return repository.saveWeight(weight);
  }
}