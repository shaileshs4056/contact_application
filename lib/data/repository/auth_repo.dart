import 'package:contact_number_demo/core/api/base_response/base_response.dart';
import 'package:contact_number_demo/data/model/request/login_request_model.dart';
import 'package:contact_number_demo/data/model/response/user_profile_response.dart';

abstract class AuthRepository {
  Future<BaseResponse<UserData?>> signIn(LoginRequestModel request);

  Future<BaseResponse> logout();
}
