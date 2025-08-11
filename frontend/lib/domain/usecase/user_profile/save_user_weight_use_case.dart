import 'package:workoutride/domain/model/user_profile.dart';
import 'package:workoutride/domain/repository/user_profile_repository.dart';

class SaveUserWeightUseCase {
  final UserProfileRepository repository;

  SaveUserWeightUseCase({required this.repository});

  Future<void> call(double weight) {
    final profile = UserProfile(
      weight: weight,
      updatedAt: DateTime.now(),
    );
    return repository.saveUserProfile(profile);
  }
}