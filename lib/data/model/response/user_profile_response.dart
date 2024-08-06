import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_response.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 0)
class UserData {
  @HiveField(0)
  @JsonKey(name: "id")
  int? id;
  @HiveField(1)
  @JsonKey(name: "mobile_number")
  String? mobileNumber;
  @HiveField(2)
  @JsonKey(name: "signup_with")
  String? signupWith;
  @HiveField(3)
  @JsonKey(name: "name")
  String? name;
  @HiveField(4)
  @JsonKey(name: "email")
  String? email;
  @HiveField(5)
  @JsonKey(name: "country_code")
  String? countryCode;
  @HiveField(6)
  @JsonKey(name: "profile_image")
  String? profileImage;
  @HiveField(7)
  @JsonKey(name: "token")
  String? token;
  @HiveField(8)
  @JsonKey(name: "date_of_birth")
  String? dob;
  @HiveField(9)
  @JsonKey(name: "gender")
  String? gender;
  @HiveField(10)
  @JsonKey(name: "login_type")
  String? loginType;
  @HiveField(11)
  @JsonKey(name: "first_name")
  String? firstName;
  @HiveField(12)
  @JsonKey(name: "last_name")
  String? lastName;
  @HiveField(13)
  @JsonKey(name: "referal_code")
  String? referralCode;
  @HiveField(14)
  @JsonKey(name: "coin")
  int? coin;
  @HiveField(15)
  @JsonKey(name: "hotword_total")
  int? hotwordTotal;
  @HiveField(16)
  @JsonKey(name: "sample_app_play_total")
  int? playTotal;
  @HiveField(17)
  @JsonKey(name: "story_read")
  int? storyTotal;
  @HiveField(18)
  @JsonKey(name: "joining_bonus")
  int? joiningBonus;
  @HiveField(19)
  @JsonKey(name: "refer_total")
  int? referTotal;
  @JsonKey(name: "social_id")
  String? socialId;

  UserData({
    this.id,
    this.mobileNumber,
    this.signupWith,
    this.name,
    this.email,
    this.token,
    this.profileImage,
    this.countryCode,
    this.dob,
    this.gender,
    this.loginType,
    this.firstName,
    this.lastName,
    this.referralCode,
    this.coin,
    this.hotwordTotal,
    this.playTotal,
    this.storyTotal,
    this.joiningBonus,
    this.referTotal,
    this.socialId,
  });

  static UserData fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
