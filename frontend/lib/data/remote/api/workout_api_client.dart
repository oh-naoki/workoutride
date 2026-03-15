import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:workoutride/data/remote/model/workout_block_dto.dart';
import 'package:workoutride/data/remote/model/workout_result_dto.dart';
import 'package:workoutride/data/remote/model/workout_summary_dto.dart';

part 'workout_api_client.g.dart';

@RestApi(baseUrl: "")
abstract class WorkoutApiClient {
  factory WorkoutApiClient(Dio dio) = _WorkoutApiClient;

  @GET("/workout_summaries")
  Future<List<WorkoutSummaryDto>> getWorkoutSummaries();

  @GET("/workout_blocks/{id}")
  Future<List<WorkoutBlockDto>> getWorkoutBlocks(@Path("id") int workoutId);

  @GET("/workout_results")
  Future<List<WorkoutResultDto>> getWorkoutResults();

  @GET("/workout_results/{id}")
  Future<WorkoutResultDto> getWorkoutResult(@Path("id") int id);

  @POST("/workout_results")
  Future<WorkoutResultDto> saveWorkoutResult(@Body() Map<String, dynamic> body);
}
