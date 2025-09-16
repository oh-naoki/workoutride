import 'package:workoutride/data/remote/model/workout_block_dto.dart';
import 'package:workoutride/data/remote/model/workout_summary_dto.dart';
import 'package:workoutride/domain/model/workout/workout_block.dart';
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
