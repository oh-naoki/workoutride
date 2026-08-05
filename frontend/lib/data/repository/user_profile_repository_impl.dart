import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workoutride/data/remote/api/user_ftp_api_client.dart';
import 'package:workoutride/data/remote/api/user_profile_api_client.dart';
import 'package:workoutride/data/remote/error/exception_mapper.dart';
import 'package:workoutride/domain/model/user_profile.dart';
import 'package:workoutride/domain/repository/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final SharedPreferences sharedPreferences;
  final UserFtpApiClient userFtpApiClient;
  final UserProfileApiClient userProfileApiClient;
  static const String _userProfileKey = 'user_profile';

  UserProfileRepositoryImpl({
    required this.sharedPreferences,
    required this.userFtpApiClient,
    required this.userProfileApiClient,
  });

  @override
  Future<UserProfile?> getUserProfile() async {
    final weight = await getWeight();
    final ftp = await getFtp();
    if (weight == null && ftp == null) return null;
    return UserProfile(
      weight: weight ?? 0,
      ftp: ftp ?? 200,
      updatedAt: DateTime.now(),
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
    try {
      final response = await userFtpApiClient.getCurrentFtp();
      return response.ftp_value;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return await _migrateLocalFtpToBackend();
      }
      throw mapToAppException(e);
    }
  }

  @override
  Future<void> saveFtp(int ftp) {
    return guardApiCall(() => userFtpApiClient.saveFtp({'ftp_value': ftp}));
  }

  @override
  Future<double?> getWeight() async {
    try {
      final response = await userProfileApiClient.getUserProfile();
      if (response.weight != null) return response.weight;
      return await _migrateLocalWeightToBackend();
    } on DioException {
      return _getLocalWeight();
    }
  }

  @override
  Future<void> saveWeight(double weight) {
    return guardApiCall(
      () => userProfileApiClient.updateUserProfile({'weight': weight}),
    );
  }

  Future<int?> _migrateLocalFtpToBackend() async {
    final localFtp = await _getLocalFtp();
    if (localFtp == null || localFtp == 0) return null;
    try {
      await userFtpApiClient.saveFtp({'ftp_value': localFtp});
    } catch (_) {
      // Migration failed, return local value as fallback
    }
    return localFtp;
  }

  Future<double?> _migrateLocalWeightToBackend() async {
    final localWeight = await _getLocalWeight();
    if (localWeight == null || localWeight == 0) return null;
    try {
      await userProfileApiClient.updateUserProfile({'weight': localWeight});
    } catch (_) {
      // Migration failed, return local value as fallback
    }
    return localWeight;
  }

  Future<int?> _getLocalFtp() async {
    final jsonString = sharedPreferences.getString(_userProfileKey);
    if (jsonString == null) return null;
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return json['ftp'] as int?;
  }

  Future<double?> _getLocalWeight() async {
    final jsonString = sharedPreferences.getString(_userProfileKey);
    if (jsonString == null) return null;
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return json['weight'] as double?;
  }
}
