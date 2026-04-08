import 'package:workoutride/domain/model/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile?> getUserProfile();
  Future<void> saveUserProfile(UserProfile profile);
  Future<int?> getFtp();
  Future<void> saveFtp(int ftp);
  Future<double?> getWeight();
  Future<void> saveWeight(double weight);
}