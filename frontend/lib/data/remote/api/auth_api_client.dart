import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:workoutride/data/remote/model/auth/auth_response_dto.dart';
import 'package:workoutride/data/remote/model/auth/user_dto.dart';

part 'auth_api_client.g.dart';

@RestApi(baseUrl: "http://192.168.0.168:3000/api/v1")
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST("/auth/google")
  Future<AuthResponseDto> googleSignIn(@Body() Map<String, dynamic> body);

  @DELETE("/auth/logout")
  Future<void> logout();

  @GET("/auth/me")
  Future<UserDto> getCurrentUser();
}
