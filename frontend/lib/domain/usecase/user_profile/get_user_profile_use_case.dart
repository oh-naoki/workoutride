import 'package:workoutride/domain/model/user_profile.dart';
import 'package:workoutride/domain/repository/user_profile_repository.dart';

class GetUserProfileUseCase {
  final UserProfileRepository repository;

  GetUserProfileUseCase({required this.repository});

  Future<UserProfile?> call() {
    return repository.getUserProfile();
  }
}