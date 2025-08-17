import 'package:workoutride/domain/model/user_profile.dart';
import 'package:workoutride/domain/repository/user_profile_repository.dart';

class SaveUserWeightUseCase {
  final UserProfileRepository repository;

  SaveUserWeightUseCase({required this.repository});

  Future<void> call(double weight) async {
    // 既存のFTPを取得
    final currentFtp = await repository.getFtp();
    final ftp = currentFtp ?? 200; // デフォルト200W
    
    final profile = UserProfile(
      weight: weight,
      ftp: ftp,
      updatedAt: DateTime.now(),
    );
    return repository.saveUserProfile(profile);
  }
}