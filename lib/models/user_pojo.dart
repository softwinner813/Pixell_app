// To parse this JSON data, do
//
//     final userPojo = userPojoFromJson(jsonString);

import 'dart:convert';

UserPojo userPojoFromJson(String str) => UserPojo.fromJson(json.decode(str));

String userPojoToJson(UserPojo data) => json.encode(data.toJson());

class UserPojo {
  String token;
  bool logged;
  int id;
  String error;
  bool success;
  String detail;

  UserPojo(
      {this.token,
      this.logged,
      this.id,
      this.error,
      this.success,
      this.detail});

  factory UserPojo.fromJson(Map<String, dynamic> json) => UserPojo(
        token: json["token"],
        logged: json["logged"],
        id: json["id"],
        error: json["error"],
        success: json["success"],
        detail: json["detail"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "logged": logged,
        "id": id,
        "error": error,
        "success": success,
        "error": detail,
      };
}
