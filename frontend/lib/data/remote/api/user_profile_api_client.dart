import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:workoutride/data/remote/model/user_profile_dto.dart';

part 'user_profile_api_client.g.dart';

@RestApi(baseUrl: "")
abstract class UserProfileApiClient {
  factory UserProfileApiClient(Dio dio) = _UserProfileApiClient;

  @GET("/user_profile")
  Future<UserProfileDto> getUserProfile();

  @PUT("/user_profile")
  Future<UserProfileDto> updateUserProfile(@Body() Map<String, dynamic> body);
}
