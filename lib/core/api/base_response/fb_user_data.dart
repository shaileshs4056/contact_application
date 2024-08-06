// To parse this JSON data, do
//
//     final fbUserResponse = fbUserResponseFromJson(jsonString);

import 'dart:convert';

UserDataResponse fbUserResponseFromJson(String str) =>
    UserDataResponse.fromJson(json.decode(str));

String fbUserResponseToJson(UserDataResponse data) =>
    json.encode(data.toJson());

class UserDataResponse {
  UserDataResponse({
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.sub,
  });

  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? sub;

  factory UserDataResponse.fromJson(Map<String, dynamic> json) =>
      UserDataResponse(
        name: json["name"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        sub: json["sub"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "sub": sub,
      };
}
