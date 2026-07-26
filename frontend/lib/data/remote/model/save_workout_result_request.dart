class SaveWorkoutResultRequest {
  final int workoutSummaryId;
  final String startedAt;
  final String? finishedAt;
  final int totalDurationSeconds;
  final int? averagePower;
  final int? maxPower;
  final int? averageCadence;
  final String status;
  final List<SaveWorkoutBlockResultRequest> workoutBlockResults;

  const SaveWorkoutResultRequest({
    required this.workoutSummaryId,
    required this.startedAt,
    this.finishedAt,
    required this.totalDurationSeconds,
    this.averagePower,
    this.maxPower,
    this.averageCadence,
    required this.status,
    this.workoutBlockResults = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'workout_summary_id': workoutSummaryId,
      'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      'total_duration_seconds': totalDurationSeconds,
      if (averagePower != null) 'average_power': averagePower,
      if (maxPower != null) 'max_power': maxPower,
      if (averageCadence != null) 'average_cadence': averageCadence,
      'status': status,
      if (workoutBlockResults.isNotEmpty)
        'workout_block_results':
            workoutBlockResults.map((e) => e.toJson()).toList(),
    };
  }
}

class SaveWorkoutBlockResultRequest {
  final int workoutBlockId;
  final int? averagePower;
  final int? maxPower;
  final int? averageCadence;
  final int durationSeconds;

  const SaveWorkoutBlockResultRequest({
    required this.workoutBlockId,
    this.averagePower,
    this.maxPower,
    this.averageCadence,
    required this.durationSeconds,
  });

  Map<String, dynamic> toJson() {
    return {
      'workout_block_id': workoutBlockId,
      if (averagePower != null) 'average_power': averagePower,
      if (maxPower != null) 'max_power': maxPower,
      if (averageCadence != null) 'average_cadence': averageCadence,
      'duration_seconds': durationSeconds,
    };
  }
}
