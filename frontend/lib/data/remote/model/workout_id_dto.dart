import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_id_dto.freezed.dart';
part 'workout_id_dto.g.dart';

@freezed
class WorkoutIdDto with _$WorkoutIdDto {
  const factory WorkoutIdDto({
    required int id,
  }) = _WorkoutIdDto;

  factory WorkoutIdDto.fromJson(Map<String, dynamic> json) =>
      _$WorkoutIdDtoFromJson(json);
}
