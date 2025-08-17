import 'package:workoutride/domain/repository/user_profile_repository.dart';

class SaveUserFtpUseCase {
  final UserProfileRepository _userProfileRepository;

  SaveUserFtpUseCase(this._userProfileRepository);

  Future<void> call(int ftp) async {
    await _userProfileRepository.saveFtp(ftp);
  }
}
