import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_summary_dto.freezed.dart';
part 'workout_summary_dto.g.dart';

@freezed
class WorkoutSummaryDto with _$WorkoutSummaryDto {
  const factory WorkoutSummaryDto({
    required int id,
    required String name,
    required int total_duration,
    required String category,
    required String created_at,
    required String updated_at,
  }) = _WorkoutSummaryDto;

  factory WorkoutSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSummaryDtoFromJson(json);
}
