import 'package:json_annotation/json_annotation.dart';

part 'login_request_model.g.dart';

@JsonSerializable(
  ignoreUnannotated: false,
  includeIfNull: false,
)
class LoginRequestModel {
  @JsonKey(name: 'email')
  String? email;
  @JsonKey(name: 'user_type')
  String? userType;
  @JsonKey(name: 'login_type')
  String? loginType;
  @JsonKey(name: 'device_type')
  String? deviceType;
  @JsonKey(name: 'device_token')
  String? deviceToken;
  @JsonKey(name: 'country_code')
  String? countryCode;
  @JsonKey(name: 'phone')
  String? phone;
  @JsonKey(name: 'password')
  String? password;
  @JsonKey(name: 'address')
  String? address;
  @JsonKey(name: 'latitude')
  String? latitude;
  @JsonKey(name: 'longitude')
  String? longitude;
  @JsonKey(name: 'ip')
  String? ip;
  @JsonKey(name: 'uuid')
  String? uuid;
  @JsonKey(name: 'os_version')
  String? osVersion;
  @JsonKey(name: 'device_model')
  String? deviceModel;
  @JsonKey(name: 'social_id')
  String? socialId;

  LoginRequestModel(
      {this.email,
      this.userType,
      this.loginType,
      this.deviceType,
      this.deviceToken,
      this.countryCode,
      this.phone,
      this.password,
      this.address,
      this.latitude,
      this.longitude,
      this.ip,
      this.uuid,
      this.osVersion,
      this.deviceModel,
      this.socialId});

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);
}
