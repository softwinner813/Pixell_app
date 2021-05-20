// To parse this JSON data, do
//
//     final logoutPojo = logoutPojoFromJson(jsonString);

import 'dart:convert';

LogoutPojo logoutPojoFromJson(String str) => LogoutPojo.fromJson(json.decode(str));

String logoutPojoToJson(LogoutPojo data) => json.encode(data.toJson());

class LogoutPojo {
  bool logged;
  String detail;
  String statusCode;

  LogoutPojo({
    this.logged,
    this.detail,
    this.statusCode,
  });

  factory LogoutPojo.fromJson(Map<String, dynamic> json) => LogoutPojo(
    logged: json["logged"],
    detail: json["detail"],
    statusCode: json["status_code"],
  );

  Map<String, dynamic> toJson() => {
    "logged": logged,
    "detail": detail,
    "status_code": statusCode,
  };
}
