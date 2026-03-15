import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:workoutride/data/remote/model/user_ftp_dto.dart';

part 'user_ftp_api_client.g.dart';

@RestApi(baseUrl: "")
abstract class UserFtpApiClient {
  factory UserFtpApiClient(Dio dio) = _UserFtpApiClient;

  @GET("/user_ftps/current")
  Future<UserFtpDto> getCurrentFtp();

  @POST("/user_ftps")
  Future<UserFtpDto> saveFtp(@Body() Map<String, dynamic> body);
}
