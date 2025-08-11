
class WorkoutBlockDto {
  final int id;
  final int workout_id;
  final int order_index;
  final double target_pwr;
  final int duration;
  final String block_type;
  final String created_at;
  final String updated_at;

  const WorkoutBlockDto({
    required this.id,
    required this.workout_id,
    required this.order_index,
    required this.target_pwr,
    required this.duration,
    required this.block_type,
    required this.created_at,
    required this.updated_at,
  });

  factory WorkoutBlockDto.fromJson(Map<String, dynamic> json) {
    return WorkoutBlockDto(
      id: json['id'] is String ? int.parse(json['id']) : (json['id'] as num).toInt(),
      workout_id: json['workout_id'] is String ? int.parse(json['workout_id']) : (json['workout_id'] as num).toInt(),
      order_index: json['order_index'] is String ? int.parse(json['order_index']) : (json['order_index'] as num).toInt(),
      target_pwr: json['target_pwr'] is String ? double.parse(json['target_pwr']) : (json['target_pwr'] as num).toDouble(),
      duration: json['duration'] is String ? int.parse(json['duration']) : (json['duration'] as num).toInt(),
      block_type: json['block_type'] as String,
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workout_id': workout_id,
      'order_index': order_index,
      'target_pwr': target_pwr,
      'duration': duration,
      'block_type': block_type,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
