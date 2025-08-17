import 'package:workoutride/domain/repository/user_profile_repository.dart';

class GetUserFtpUseCase {
  final UserProfileRepository _userProfileRepository;

  GetUserFtpUseCase(this._userProfileRepository);

  Future<int?> call() async {
    return await _userProfileRepository.getFtp();
  }
}
