// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_ftp_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserFtpDtoImpl _$$UserFtpDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserFtpDtoImpl(
      id: (json['id'] as num).toInt(),
      ftp_value: (json['ftp_value'] as num).toInt(),
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
    );

Map<String, dynamic> _$$UserFtpDtoImplToJson(_$UserFtpDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ftp_value': instance.ftp_value,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };
