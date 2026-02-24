import 'package:workoutride/data/remote/model/workout_block_result_dto.dart';

class WorkoutResultDto {
  final int id;
  final int workout_summary_id;
  final String started_at;
  final String? finished_at;
  final int total_duration_seconds;
  final int? average_power;
  final int? max_power;
  final int? average_cadence;
  final String status;
  final String created_at;
  final String updated_at;
  final List<WorkoutBlockResultDto> workout_block_results;

  const WorkoutResultDto({
    required this.id,
    required this.workout_summary_id,
    required this.started_at,
    this.finished_at,
    required this.total_duration_seconds,
    this.average_power,
    this.max_power,
    this.average_cadence,
    required this.status,
    required this.created_at,
    required this.updated_at,
    this.workout_block_results = const [],
  });

  factory WorkoutResultDto.fromJson(Map<String, dynamic> json) {
    return WorkoutResultDto(
      id: (json['id'] as num).toInt(),
      workout_summary_id: (json['workout_summary_id'] as num).toInt(),
      started_at: json['started_at'] as String,
      finished_at: json['finished_at'] as String?,
      total_duration_seconds: (json['total_duration_seconds'] as num).toInt(),
      average_power: json['average_power'] != null ? (json['average_power'] as num).toInt() : null,
      max_power: json['max_power'] != null ? (json['max_power'] as num).toInt() : null,
      average_cadence: json['average_cadence'] != null ? (json['average_cadence'] as num).toInt() : null,
      status: json['status'] as String,
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
      workout_block_results: (json['workout_block_results'] as List<dynamic>?)
              ?.map((e) => WorkoutBlockResultDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workout_summary_id': workout_summary_id,
      'started_at': started_at,
      'finished_at': finished_at,
      'total_duration_seconds': total_duration_seconds,
      'average_power': average_power,
      'max_power': max_power,
      'average_cadence': average_cadence,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'workout_block_results': workout_block_results.map((e) => e.toJson()).toList(),
    };
  }
}
