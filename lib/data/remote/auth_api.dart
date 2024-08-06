import 'package:dio/dio.dart';
import 'package:contact_number_demo/core/api/base_response/base_response.dart';
import 'package:contact_number_demo/data/model/request/login_request_model.dart';
import 'package:contact_number_demo/data/model/response/user_profile_response.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;

  @POST('/user_authentication/signin')
  Future<BaseResponse<UserData?>> signIn(@Body() LoginRequestModel request);

  @POST('/user_authentication/logout')
  Future<BaseResponse> logout();
}
