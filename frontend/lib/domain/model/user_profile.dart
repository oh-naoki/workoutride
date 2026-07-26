import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required double weight,
    required int ftp,
    required DateTime updatedAt,
  }) = _UserProfile;
}
