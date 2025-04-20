import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:workoutride/data/remote/model/workout_block_dto.dart';
import 'package:workoutride/data/remote/model/workout_summary_dto.dart';

part 'workout_api_client.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:3000/api/v1")
abstract class WorkoutApiClient {
  factory WorkoutApiClient(Dio dio) = _WorkoutApiClient;

  @GET("/workout_summaries")
  Future<List<WorkoutSummaryDto>> getWorkoutSummaries();

  @GET("/workout_blocks/{id}")
  Future<List<WorkoutBlockDto>> getWorkoutBlocks(@Path("id") int workoutId);
}
