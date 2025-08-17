import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workoutride/domain/model/user_profile.dart';
import 'package:workoutride/domain/repository/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final SharedPreferences sharedPreferences;
  static const String _userProfileKey = 'user_profile';
  static const String _ftpKey = 'user_ftp';

  UserProfileRepositoryImpl({
    required this.sharedPreferences,
  });

  @override
  Future<UserProfile?> getUserProfile() async {
    final jsonString = sharedPreferences.getString(_userProfileKey);
    if (jsonString == null) return null;
    
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return UserProfile(
      weight: json['weight'] as double,
      ftp: json['ftp'] as int,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    final json = {
      'weight': profile.weight,
      'ftp': profile.ftp,
      'updatedAt': profile.updatedAt.toIso8601String(),
    };
    await sharedPreferences.setString(_userProfileKey, jsonEncode(json));
  }

  @override
  Future<int?> getFtp() async {
    return sharedPreferences.getInt(_ftpKey);
  }

  @override
  Future<void> saveFtp(int ftp) async {
    await sharedPreferences.setInt(_ftpKey, ftp);
  }
}