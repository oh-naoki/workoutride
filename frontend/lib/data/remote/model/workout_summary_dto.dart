import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:workoutride/data/remote/model/workout_id_dto.dart';

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
    required List<WorkoutIdDto> workouts,
  }) = _WorkoutSummaryDto;

  factory WorkoutSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSummaryDtoFromJson(json);
}
