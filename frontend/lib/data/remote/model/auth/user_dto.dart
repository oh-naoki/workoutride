import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:workoutride/domain/model/auth/user.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDto with _$UserDto {
  const UserDto._();

  const factory UserDto({
    required int id,
    required String provider,
    required String uid,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  User toDomain() => User(
        id: id,
        provider: provider,
        uid: uid,
      );
}
