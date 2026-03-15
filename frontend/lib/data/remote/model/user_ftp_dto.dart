import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_ftp_dto.freezed.dart';
part 'user_ftp_dto.g.dart';

@freezed
class UserFtpDto with _$UserFtpDto {
  const factory UserFtpDto({
    required int id,
    required int ftp_value,
    required String created_at,
    required String updated_at,
  }) = _UserFtpDto;

  factory UserFtpDto.fromJson(Map<String, dynamic> json) =>
      _$UserFtpDtoFromJson(json);
}
