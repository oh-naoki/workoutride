class WorkoutBlockResultDto {
  final int id;
  final int workout_result_id;
  final int workout_block_id;
  final int? average_power;
  final int? max_power;
  final int? average_cadence;
  final int duration_seconds;
  final String created_at;
  final String updated_at;

  const WorkoutBlockResultDto({
    required this.id,
    required this.workout_result_id,
    required this.workout_block_id,
    this.average_power,
    this.max_power,
    this.average_cadence,
    required this.duration_seconds,
    required this.created_at,
    required this.updated_at,
  });

  factory WorkoutBlockResultDto.fromJson(Map<String, dynamic> json) {
    return WorkoutBlockResultDto(
      id: (json['id'] as num).toInt(),
      workout_result_id: (json['workout_result_id'] as num).toInt(),
      workout_block_id: (json['workout_block_id'] as num).toInt(),
      average_power: json['average_power'] != null
          ? (json['average_power'] as num).toInt()
          : null,
      max_power:
          json['max_power'] != null ? (json['max_power'] as num).toInt() : null,
      average_cadence: json['average_cadence'] != null
          ? (json['average_cadence'] as num).toInt()
          : null,
      duration_seconds: (json['duration_seconds'] as num).toInt(),
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workout_result_id': workout_result_id,
      'workout_block_id': workout_block_id,
      'average_power': average_power,
      'max_power': max_power,
      'average_cadence': average_cadence,
      'duration_seconds': duration_seconds,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
