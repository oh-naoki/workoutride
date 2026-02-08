import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:workoutride/data/remote/api/auth_api_client.dart';
import 'package:workoutride/domain/model/auth/user.dart';
import 'package:workoutride/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiClient _apiClient;
  final GoogleSignIn _googleSignIn;
  final FlutterSecureStorage _secureStorage;

  static const _tokenKey = 'auth_token';

  AuthRepositoryImpl(
    this._apiClient,
    this._googleSignIn,
    this._secureStorage,
  );

  @override
  Future<User> signInWithGoogle() async {
    // 1. Google Sign-In
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign in cancelled');
    }

    final googleAuth = await googleUser.authentication;
    if (googleAuth.idToken == null) {
      throw Exception('Failed to get ID token');
    }

    // 2. Backend認証
    final response = await _apiClient.googleSignIn({
      'id_token': googleAuth.idToken!,
    });

    // 3. トークン保存
    await _secureStorage.write(key: _tokenKey, value: response.token);

    // 4. Userを返す（provider, uid含む）
    return response.user.toDomain();
  }

  @override
  Future<void> signOut() async {
    try {
      await _apiClient.logout();
    } catch (_) {}

    await _googleSignIn.signOut();
    await _secureStorage.delete(key: _tokenKey);
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await _secureStorage.read(key: _tokenKey);
    if (token == null) return null;

    try {
      final userDto = await _apiClient.getCurrentUser();
      return userDto.toDomain();
    } catch (_) {
      return null;
    }
  }
}
