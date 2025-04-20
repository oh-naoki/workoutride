// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_block_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutBlockDtoImpl _$$WorkoutBlockDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkoutBlockDtoImpl(
      id: (json['id'] as num).toInt(),
      workout_id: (json['workout_id'] as num).toInt(),
      order_index: (json['order_index'] as num).toInt(),
      target_power: (json['target_power'] as num).toInt(),
      duration: (json['duration'] as num).toInt(),
      block_type: json['block_type'] as String,
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
    );

Map<String, dynamic> _$$WorkoutBlockDtoImplToJson(
        _$WorkoutBlockDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workout_id': instance.workout_id,
      'order_index': instance.order_index,
      'target_power': instance.target_power,
      'duration': instance.duration,
      'block_type': instance.block_type,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };
