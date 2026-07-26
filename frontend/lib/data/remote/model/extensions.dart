import 'package:workoutride/data/remote/model/workout_block_dto.dart';
import 'package:workoutride/data/remote/model/workout_block_result_dto.dart';
import 'package:workoutride/data/remote/model/workout_result_dto.dart';
import 'package:workoutride/data/remote/model/workout_summary_dto.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
import 'package:workoutride/domain/model/workout/workout_block_result.dart';
import 'package:workoutride/domain/model/workout/workout_result.dart';
import 'package:workoutride/domain/model/workout/workout_summary.dart';

extension WorkoutBlockDtoExtension on WorkoutBlockDto {
  WorkoutBlock toDomain() {
    return WorkoutBlock(
      id: id,
      workoutId: workout_summary_id,
      orderIndex: order_index,
      targetFtpPercentage: target_ftp_percentage,
      durationSeconds: duration,
      blockType: block_type,
      createdAt: DateTime.parse(created_at),
      updatedAt: DateTime.parse(updated_at),
    );
  }
}

extension WorkoutSummaryDtoExtension on WorkoutSummaryDto {
  WorkoutSummary toDomain() {
    return WorkoutSummary(
      id: id,
      name: name,
      totalDuration: total_duration,
      category: category,
      createdAt: DateTime.parse(created_at),
      updatedAt: DateTime.parse(updated_at),
    );
  }
}

extension WorkoutResultDtoExtension on WorkoutResultDto {
  WorkoutResult toDomain() {
    return WorkoutResult(
      id: id,
      workoutSummaryId: workout_summary_id,
      startedAt: DateTime.parse(started_at),
      finishedAt: finished_at != null ? DateTime.parse(finished_at!) : null,
      totalDurationSeconds: total_duration_seconds,
      averagePower: average_power,
      maxPower: max_power,
      averageCadence: average_cadence,
      status: status,
      createdAt: DateTime.parse(created_at),
      updatedAt: DateTime.parse(updated_at),
      workoutBlockResults:
          workout_block_results.map((e) => e.toDomain()).toList(),
    );
  }
}

extension WorkoutBlockResultDtoExtension on WorkoutBlockResultDto {
  WorkoutBlockResult toDomain() {
    return WorkoutBlockResult(
      id: id,
      workoutResultId: workout_result_id,
      workoutBlockId: workout_block_id,
      averagePower: average_power,
      maxPower: max_power,
      averageCadence: average_cadence,
      durationSeconds: duration_seconds,
      createdAt: DateTime.parse(created_at),
      updatedAt: DateTime.parse(updated_at),
    );
  }
}
