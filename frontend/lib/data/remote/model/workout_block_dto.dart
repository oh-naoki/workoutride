import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_block_dto.freezed.dart';
part 'workout_block_dto.g.dart';

@freezed
class WorkoutBlockDto with _$WorkoutBlockDto {
  const factory WorkoutBlockDto({
    required int id,
    required int workout_id,
    required int order_index,
    required int target_power,
    required int duration,
    required String block_type,
    required String created_at,
    required String updated_at,
  }) = _WorkoutBlockDto;

  factory WorkoutBlockDto.fromJson(Map<String, dynamic> json) =>
      _$WorkoutBlockDtoFromJson(json);
}
