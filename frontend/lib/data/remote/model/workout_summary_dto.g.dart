// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutSummaryDtoImpl _$$WorkoutSummaryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkoutSummaryDtoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      total_duration: (json['total_duration'] as num).toInt(),
      category: json['category'] as String,
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
    );

Map<String, dynamic> _$$WorkoutSummaryDtoImplToJson(
        _$WorkoutSummaryDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'total_duration': instance.total_duration,
      'category': instance.category,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };
